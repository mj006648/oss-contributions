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

## 수정 방향 (제안)

CLI가 다음 두 모드 중 하나임을 명확히 구분한다.
- **Interactive 모드**: 옵션 없이 실행 → REPL → jline Terminal 필요
- **Non-interactive 모드**: `-c` 또는 `-s` 사용 → 결과 출력만 필요 → `System.out` PrintWriter면 충분

수정 후보:

1. `NessieCliImpl`에서 `commandsToRun != null && commandsToRun.commandsSource != null` 인 경우, jline `TerminalBuilder` 대신 `TerminalBuilder.dumb=true` 또는 `system(false).streams(System.in, System.out)` 사용.
2. 또는 `writer()` 메서드가 non-interactive일 때는 `new PrintWriter(System.out, true)`를 반환하도록 분기.
3. `--non-ansi` 옵션이 이미 존재하므로 (`OPTION_NON_ANSI`, line 93), 이 옵션 활성화 시 자동으로 plain stdout PrintWriter 쓰는 경로를 추가하는 것도 가능. 다만 redirect가 항상 동작해야 하므로 `-c`/`-s` 자체를 트리거로 삼는 게 더 자연스럽다.

가장 깔끔한 접근:
- `NessieCliImpl#call()` (또는 picocli `run()` 진입점)에서 `commandsToRun.commandsSource != null`이면 jline 빌드 분기를 **dumb terminal 또는 streams(System.in, System.out) 모드**로 전환.
- writer()는 자동으로 `new PrintWriter(System.out, true)`를 사용하게 된다.

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
