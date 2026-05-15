# Nessie #10865 — CLI STDOUT redirect 버그

- 원본 이슈: https://github.com/projectnessie/nessie/issues/10865
- 보고자: @dimas-b (Dmitri Bourlatchkov, Nessie maintainer)
- 보고일: 2025-06-03
- 라벨: good first issue
- 영향 버전: Nessie 0.103.* 이상
- 상태: **maintainer GO 사인 받음 (2026-05-15)** — `--plain`/`-P` 옵션 추가 방향 합의. 빌드 환경 셋업 후 patch 작성 단계.

## 이슈 본문 요약

다음과 같이 `--command`(`-c`) 옵션과 쉘 redirect(`>`)를 결합하면 출력이 redirect 대상 파일에 들어가지 않고 터미널로만 새어 나간다.

```
$ java -jar nessie-cli-0.103.3-SNAPSHOT.jar \
  -u http://localhost:19120/api/v2 \
  -c "create namespace ns2" \
  -c "SHOW LOG" >/tmp/log.txt
```

`cat /tmp/log.txt` 결과는 빈 파일. `--command` 또는 `--run-script` 사용 시 redirect가 동작해야 한다는 것이 보고자의 요구.

## 원인 가설 (검증 완료)

CLI 모듈은 [`cli/cli/src/main/java/org/projectnessie/nessie/cli/cli/`](https://github.com/projectnessie/nessie/tree/main/cli/cli/src/main/java/org/projectnessie/nessie/cli/cli) 하위에 있으며 핵심 파일은 다음과 같다.

- `NessieCliMain.java`         picocli 엔트리포인트
- `NessieCliImpl.java`         실제 CLI 로직 (jline Terminal 빌드, 출력 처리)
- `CommandsToRun.java`         `-c` / `-s` 옵션 정의
- `BaseNessieCli.java`         공통 base
- `NessieCliCompleter.java`, `NessieCliHighlighter.java`  REPL UI

핵심 단서 — `NessieCliImpl.java` (라인 184~200):

```java
Terminal terminal =
    TerminalBuilder.builder()
        .jansi(!dumbTerminal)
        .dumb(dumbTerminal)
        .provider(dumbTerminal ? TerminalBuilder.PROP_PROVIDER_DUMB : null)
        .build();
setTerminal(terminal);

// hard coded terminal size when redirecting (redirect detection doesn't work properly in jline
// though :( )
if (terminal.getWidth() == 0 || terminal.getHeight() == 0) {
  terminal.setSize(new Size(120, 40));
}

PrintWriter writer = writer();
```

결론:
1. CLI는 모든 출력을 `writer()` (jline `Terminal`의 `PrintWriter`)로 보냄.
2. jline `Terminal`은 OS 콘솔/PTY에 직접 쓰는 경우가 있어 `System.out` redirect 우회.
3. 코드 주석부터 "redirect detection doesn't work properly in jline" 이라고 명시 — **개발자 측에서도 인지된 한계**.
4. `-c`/`-s` 모드(non-interactive)에서는 REPL/UI가 필요 없으므로 jline 우회 가능해야 함.

## maintainer 응답 (2026-05-15)

> **@dimas-b**: "@mj006648 : you assessment looks correct to me 🙂
> Instead of `--non-ansi` I'd personally use `--plain` / `-P`, but the former works too."

해석:
- 본인 가설(jline Terminal → System.out 폴백)이 맞다고 확인.
- 새 옵션 이름은 `--plain` / `-P` 선호.
- "the former works too" = `--non-ansi`도 같은 효과 → **현재 `--non-ansi`(dumbTerminal=true) 동작이 이미 redirect 문제를 해결**한다는 의미로 읽힘.

따라서 PR 스코프는 **`--plain` / `-P`를 새 alias로 추가**하는 작은 변경이 될 가능성이 큼. 실제로 `--non-ansi`만 켜도 redirect가 동작하는지 로컬 빌드로 검증 필요.

## 수정 방향 (확정안)

이전 노트의 "자동 분기" 방향은 폐기. maintainer가 명시적 플래그를 원함.

### 변경 위치 (3곳)

**1. 상수 추가 — `NessieCliImpl.java` line 85~93**
```java
public static final String OPTION_PLAIN = "--plain";
```

**2. `@Option` `names` 배열 확장 — line 116~122**
```java
// Before
@Option(
    names = OPTION_NON_ANSI,
    description = {
      "Allows disabling the (default) ANSI mode. Disabling ANSI support can be useful in non-interactive scripts."
    },
    defaultValue = "false")
private boolean dumbTerminal;

// After
@Option(
    names = {"-P", OPTION_PLAIN, OPTION_NON_ANSI},
    description = {
      "Use plain output mode: disable ANSI mode and bypass jline cursor control. "
      + "Required for shell redirection (>, |) and piping in non-interactive runs (-c, -s)."
    },
    defaultValue = "false")
private boolean dumbTerminal;
```

**3. 문서 — `OPTION_NON_ANSI` 언급 있는 docs 갱신** (있다면). README, `docs/` 디렉토리 grep 필요.

### 조건부 — Terminal 우회 로직이 추가로 필요한 경우

만약 로컬 검증에서 `--non-ansi` 만으로는 redirect가 여전히 안 되면:
- `writer()` 메서드를 plain 모드일 때 `new PrintWriter(System.out, true)` 반환하도록 분기
- `setTerminal()` 후 `plainWriter` 필드 별도 보관
- ANSI 출력 호출(`toAnsi(terminal())`) 도 plain 모드 분기 처리

이 경우 PR 스코프 50~80줄로 증가.

### 왜 alias 방식이 안전한가

- `--non-ansi`는 이미 릴리스된 옵션 → 제거는 사용자 깨트림 = 거절 사유.
- 같은 boolean 필드(`dumbTerminal`)에 names alias 추가는 picocli 표준 패턴.
- 동작 변화 0, 추가 옵션 1개 → 리뷰 최소.

## 빌드 환경 셋업 (블로커)

로컬 빌드 시도 시 다음 에러 반복:

```
> Cannot find a Java installation on your machine (Linux 6.8.0-87-generic amd64)
  matching: {languageVersion=21, vendor=any vendor, implementation=vendor-specific,
             nativeImageCapable=false}.
  Toolchain auto-provisioning is not enabled.
```

시스템 상태:
- `/usr/lib/jvm/java-21-openjdk-amd64` 존재
- `/usr/lib/jvm/java-1.21.0-openjdk-amd64` 존재
- `java -version` → OpenJDK 21.0.10

시도한 옵션 (모두 실패):
- `JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64 ./gradlew :nessie-cli:installDist`
- `-Porg.gradle.java.installations.paths=/usr/lib/jvm/java-21-openjdk-amd64`
- `-Dorg.gradle.java.installations.paths=...`
- `--no-daemon` + 위 조합

분석: Gradle 9.5의 toolchain spec이 `nativeImageCapable=false`를 요구하는데, OpenJDK JVM 메타데이터에 이 필드가 없거나 부정확하게 보고됨. Nessie build-logic이 GraalVM/Liberica NIK를 암묵적으로 가정할 가능성.

해결책 후보 (다음 세션):
1. **Liberica NIK 21 설치** (`sdkman install java 21.0.x-nik` 또는 deb)
2. **GraalVM 21 community edition 설치**
3. `gradle.properties`에 `org.gradle.java.installations.auto-download=true` + foojay plugin 활성화로 자동 다운로드
4. Nessie의 `build-logic`에서 `nativeImageCapable` 요구 사항을 일시 비활성화 (local hack — upstream PR 대상 아님)
5. IDE(IntelliJ/VSCode + Gradle plugin)에서 빌드 — toolchain 자동 처리 기대

## 재현 절차 (빌드 환경 갖춰진 후)

1. Nessie 서버 실행
   ```bash
   docker run -p 19120:19120 ghcr.io/projectnessie/nessie:0.103.3
   ```
2. 빌드 (toolchain 해결 후)
   ```bash
   JAVA_HOME=<nik-21-path> ./gradlew :nessie-cli:installDist
   ```
3. 버그 재현 (수정 전)
   ```bash
   ./cli/cli/build/install/nessie-cli/bin/nessie-cli \
     -u http://localhost:19120/api/v2 \
     -c "SHOW LOG" >/tmp/log.txt
   cat /tmp/log.txt   # 비어있어야 버그 재현
   ```
4. `--non-ansi` 단독 검증 (alias만 충분한지 확인)
   ```bash
   ./cli/cli/build/install/nessie-cli/bin/nessie-cli \
     --non-ansi \
     -u http://localhost:19120/api/v2 \
     -c "SHOW LOG" >/tmp/log-nonansi.txt
   cat /tmp/log-nonansi.txt   # 차 있으면 → alias만으로 PR 충분
   ```
5. patch 적용 후 `--plain` / `-P` 동작 검증

## 테스트 위치

- `cli/cli/src/testFixtures/java/org/projectnessie/nessie/cli/commands/NessieCliTester.java` (line 30~59)
  - 이미 `DumbTerminal(in, out)` + `capturedOutput()` 패턴 존재
- `cli/cli/src/test/java/org/projectnessie/nessie/cli/commands/BaseTestCommand.java` (line 40~70)
- 신규 테스트 위치: `cli/cli/src/test/java/.../TestPlainOutput.java` (또는 기존 `BaseTestCommand` 확장)
- 검증 항목:
  - `--plain` 켰을 때 출력에 ANSI escape sequence 없음
  - `-P` 단축이 `--plain`과 동등
  - `--non-ansi` 기존 동작 보존 (회귀 없음)
  - (선택) redirect 시 빈 파일 안 나옴

## 작업 체크리스트

- [x] 이슈 본문 정독
- [x] 영향받는 모듈 식별 (`cli/cli/`)
- [x] 핵심 코드 위치 식별 (`NessieCliImpl#call()` line 184~200)
- [x] 원인 가설 정리 (jline Terminal이 redirect 무시)
- [x] 이슈에 의도 코멘트 게시 (https://github.com/projectnessie/nessie/issues/10865#issuecomment-4446981588)
- [x] Nessie repo fork & clone (`~/chang/Git/nessie`, upstream remote 설정 완료)
- [x] **maintainer 응답 확인** — `--plain`/`-P` 합의 (2026-05-15)
- [x] 코드 분석 갱신 (alias 방식으로 PR 스코프 축소)
- [ ] **블로커: Gradle Java toolchain (`nativeImageCapable=false`) 매칭 실패** — Liberica NIK 또는 GraalVM 설치 필요할 가능성
- [ ] 로컬 빌드 성공
- [ ] `--non-ansi` 단독 동작 검증 (PR 스코프 확정)
- [ ] patch 작성 (alias 추가 또는 alias + Terminal 우회)
- [ ] 기존 테스트 통과 확인 (`./gradlew :nessie-cli:test`)
- [ ] `--plain` 동작 검증 테스트 추가
- [ ] DCO sign-off 커밋 (`git commit -s`)
- [ ] PR 초안 작성 (이슈 #10865 링크, 동작 변화 설명, 검증 절차)
- [ ] PR 제출 (사용자와 함께 최종 검토)

## 참고

- jline TerminalBuilder API: https://github.com/jline/jline3
- picocli `@Option` aliasing: 같은 필드에 여러 이름 부여 가능 (`names = {...}`)
- Nessie build-logic toolchain: `build-logic/build.gradle.kts:jvmToolchain { languageVersion=21 }`
- 보고자 @dimas-b 는 active maintainer라 리뷰 응답이 빠를 가능성 높음
- 이미 다른 Nessie PR (#12424, Cloud Object Storage docs) APPROVED 받음 → 같은 메인테이너와 신뢰 관계 진행 중
