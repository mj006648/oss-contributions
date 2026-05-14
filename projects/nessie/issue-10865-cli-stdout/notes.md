# Nessie #10865 — CLI STDOUT redirect 버그

- 원본 이슈: https://github.com/projectnessie/nessie/issues/10865
- 보고자: @dimas-b (Dmitri Bourlatchkov, Nessie maintainer)
- 보고일: 2025-06-03
- 라벨: good first issue
- 영향 버전: Nessie 0.103.* 이상
- 상태: 분석 완료, 재현·수정 단계 대기

## 이슈 본문 요약

다음과 같이 `--command`(`-c`) 옵션과 쉘 redirect(`>`)를 결합하면 출력이 redirect 대상 파일에 들어가지 않고 터미널로만 새어 나간다.

```
$ java -jar nessie-cli-0.103.3-SNAPSHOT.jar \
  -u http://localhost:19120/api/v2 \
  -c "create namespace ns2" \
  -c "SHOW LOG" >/tmp/log.txt
```

`cat /tmp/log.txt` 결과는 빈 파일. `--command` 또는 `--run-script` 사용 시 redirect가 동작해야 한다는 것이 보고자의 요구.

## 원인 가설

CLI 모듈은 [`cli/cli/src/main/java/org/projectnessie/nessie/cli/cli/`](https://github.com/projectnessie/nessie/tree/main/cli/cli/src/main/java/org/projectnessie/nessie/cli/cli) 하위에 있으며 핵심 파일은 다음과 같다.

- `NessieCliMain.java`         picocli 엔트리포인트
- `NessieCliImpl.java`         실제 CLI 로직 (jline Terminal 빌드, 출력 처리)
- `CommandsToRun.java`         `-c` / `-s` 옵션 정의
- `BaseNessieCli.java`         공통 base
- `NessieCliCompleter.java`, `NessieCliHighlighter.java`  REPL UI

가장 결정적인 단서는 `NessieCliImpl.java`의 다음 코드 (라인 184~200):

```java
Terminal terminal =
    TerminalBuilder.builder()
        .jansi(!dumbTerminal)
        ...
        .build();
setTerminal(terminal);

// hard coded terminal size when redirecting (redirect detection doesn't work properly in jline
// ...
if (terminal.getWidth() == 0 || terminal.getHeight() == 0) {
  terminal.setSize(new Size(120, 40));
}

PrintWriter writer = writer();
```

핵심:
1. CLI는 모든 출력을 `writer()` (jline `Terminal`의 `PrintWriter`)로 보낸다.
2. jline `Terminal`은 OS 콘솔/PTY에 직접 쓰는 경우가 있어 자바 `System.out` redirect 우회 가능성이 높다.
3. 코드 주석부터 "redirect detection doesn't work properly in jline" 이라고 명시되어 있어, **개발자 측에서도 이미 jline의 redirect 미지원을 인지**하고 있었다.
4. `-c`/`-s` 모드(non-interactive)에서는 REPL/UI가 필요 없으므로 jline Terminal 대신 일반 `System.out` PrintWriter를 써야 한다.

## 수정 방향 (확정안)

코드를 추가로 읽은 결과, `NessieCliImpl#call()` (line 183~189)에 이미 `dumbTerminal` 분기가 존재한다. 즉 사용자가 `--dumb` 같은 옵션을 켜면 dumb terminal로 빌드되도록 되어 있다. 그러나 `-c`/`-s` 같은 non-interactive 실행 시에는 사용자가 이를 인지하기 어렵고, 기본 동작이 jline 인터랙티브 모드이므로 쉘 redirect가 동작하지 않는다.

수정 전략: **`-c` 또는 `-s` + non-keepRunning 조합이면 자동으로 dumb terminal로 빌드**한다. 사용자가 명시 옵션을 추가할 필요 없이 redirect가 자연스럽게 동작한다.

### Patch 제안 (`NessieCliImpl.java` line 183~189)

```java
// Before
@Override
public Integer call() throws Exception {
  Terminal terminal =
      TerminalBuilder.builder()
          .jansi(!dumbTerminal)
          .dumb(dumbTerminal)
          .provider(dumbTerminal ? TerminalBuilder.PROP_PROVIDER_DUMB : null)
          .build();

  setTerminal(terminal);
```

```java
// After
@Override
public Integer call() throws Exception {
  boolean nonInteractive =
      commandsToRun != null
          && commandsToRun.commandsSource != null
          && !commandsToRun.keepRunning;
  boolean useDumbTerminal = dumbTerminal || nonInteractive;

  Terminal terminal =
      TerminalBuilder.builder()
          .jansi(!useDumbTerminal)
          .dumb(useDumbTerminal)
          .provider(useDumbTerminal ? TerminalBuilder.PROP_PROVIDER_DUMB : null)
          .build();

  setTerminal(terminal);
```

### 왜 이 변경이 안전한가

- `keepRunning`이 true면 REPL이 계속 살아야 하므로 jline 인터랙티브 모드 유지.
- `commandsToRun.commandsSource`가 null이면(즉 옵션 없이 그냥 REPL 들어가는 경우) 기존 동작 그대로.
- `dumbTerminal`이 명시되었으면 이미 dumb이므로 OR로 결합해도 영향 없음.
- 변경 라인은 6줄 미만, 기존 분기 구조를 그대로 활용.

### 추가 검토 필요 사항

- 배너 출력(`writer.print(readResource(dumbTerminal ? "banner-plain.txt" : "banner.txt"))`)이 dumbTerminal 여부에 따라 다른 파일을 읽는다. non-interactive에서도 plain 배너가 노출될 수 있으니 `quiet` 옵션과 조합해 노이즈를 피하는 게 적절. (별도 PR 거리 또는 같은 PR에 포함 가능)
- 테스트: `cli/cli/src/test/java/...`에 redirect 검증 테스트가 있는지 확인 후 새 케이스 추가.

### maintainer 확인이 꼭 필요한 부분

코멘트(2026-05-14)에서 다음을 물어본 상태:
- 위 자동 분기가 맞는 방향인지
- 아니면 `--non-ansi` 옵션 활성화 또는 별도 플래그 도입이 더 적절한지

응답 받기 전까지 실제 코드 변경은 보류.

## 재현 절차

1. Nessie 서버 실행 (docker compose 또는 quarkus dev 모드)
   ```bash
   docker run -p 19120:19120 ghcr.io/projectnessie/nessie:0.103.3
   ```
2. CLI jar 다운로드
   ```bash
   wget https://github.com/projectnessie/nessie/releases/download/nessie-0.103.3/nessie-cli-0.103.3.jar
   ```
3. redirect 시도
   ```bash
   java -jar nessie-cli-0.103.3.jar \
     -u http://localhost:19120/api/v2 \
     -c "SHOW LOG" >/tmp/log.txt
   cat /tmp/log.txt   # 비어있어야 버그 재현
   ```

## 작업 체크리스트

- [x] 이슈 본문 정독
- [x] 영향받는 모듈 식별 (`cli/cli/`)
- [x] 핵심 코드 위치 식별 (`NessieCliImpl#call()` 부근, line 184~200)
- [x] 원인 가설 정리 (jline Terminal이 redirect 무시)
- [x] 이슈에 의도 코멘트 게시 (https://github.com/projectnessie/nessie/issues/10865#issuecomment-4446981588)
- [x] Nessie repo fork & clone (`~/chang/Git/nessie`, upstream remote 설정 완료)
- [ ] maintainer 응답 확인
- [ ] **Gradle Java toolchain 이슈 해결** (현재 실패: `Cannot find Java installation matching languageVersion=21`)
      - 시스템에 Java 21 설치되어 있음 (`/usr/lib/jvm/java-21-openjdk-amd64`)
      - 해결책 후보:
        1. `~/.gradle/gradle.properties`에 `org.gradle.java.installations.paths=/usr/lib/jvm/java-21-openjdk-amd64` 추가
        2. `JAVA_HOME` env 설정 후 빌드
        3. `./gradlew --auto-detect`
- [ ] 로컬 빌드 확인 (`./gradlew jar testClasses` 또는 `./gradlew :nessie-cli:cli:jar`)
- [ ] 버그 로컬 재현
- [ ] 수정 작성 (non-interactive 모드에서 dumb terminal 또는 plain System.out 사용)
- [ ] 기존 테스트 통과 확인
- [ ] redirect 동작 검증 테스트 추가
- [ ] PR 초안 작성
- [ ] DCO sign-off 커밋
- [ ] PR 제출

## 참고

- jline TerminalBuilder API: https://github.com/jline/jline3
- picocli redirect: picocli 자체는 redirect 친화적이나 jline과 결합 시 동작이 달라짐
- 보고자 @dimas-b 는 active maintainer라 리뷰 응답이 빠를 가능성 높음
