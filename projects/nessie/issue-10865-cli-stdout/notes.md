# Nessie #10865 — CLI STDOUT redirect 버그

- 원본 이슈: https://github.com/projectnessie/nessie/issues/10865
- 보고자: @dimas-b (Dmitri Bourlatchkov, Nessie maintainer)
- 보고일: 2025-06-03
- 라벨: good first issue
- 영향 버전: Nessie 0.103.* 이상
- 상태: **PR [#12425](https://github.com/projectnessie/nessie/pull/12425) SUBMITTED (2026-05-15)** — `--plain`/`-P` alias 추가, 5줄 변경, 검증 매트릭스 포함. dimas-b 리뷰 대기.

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

## 빌드 환경 셋업 (해결됨)

### 증상
초기 빌드 시도 시 toolchain matching 실패:

```
> Cannot find a Java installation on your machine matching:
  {languageVersion=21, vendor=any vendor, implementation=vendor-specific,
   nativeImageCapable=false}.
```

시스템 OpenJDK 21이 있어도 `nativeImageCapable=false` 매칭 필드에서 거부됨.

### 해결책: SDKMAN + GraalVM 21

```bash
# 1. SDKMAN 설치 (sudo 불필요, ~/.sdkman/에 설치)
curl -s "https://get.sdkman.io" | bash
source ~/.sdkman/bin/sdkman-init.sh

# 2. GraalVM 21 설치 (~500MB download, ~1GB on disk)
sdk install java 21.0.11-graal

# 3. 빌드
cd ~/chang/Git/nessie
JAVA_HOME=~/.sdkman/candidates/java/21.0.11-graal \
PATH=~/.sdkman/candidates/java/21.0.11-graal/bin:$PATH \
./gradlew :nessie-cli:shadowJar
```

- `installDist` 태스크는 nessie-cli에 없음 → **`shadowJar` 사용**
- 빌드 결과물: `cli/cli/build/libs/nessie-cli-0.107.6-SNAPSHOT.jar`
- 첫 빌드 ~2분 19초, 캐시 후 ~10초

### 시도했지만 안 된 옵션 (기록용)
- `JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64 ./gradlew ...` (OpenJDK 21 — `nativeImageCapable=false` 메타데이터 없음)
- `-Porg.gradle.java.installations.paths=...`
- `-Dorg.gradle.java.installations.paths=...`
- `--no-daemon` + 위 조합
- foojay auto-download (`-Dallow-java-download=true`) — settings.gradle.kts에서 `CI` env 또는 `allow-java-download` 시스템 속성 평가 시점 이슈

## 로컬 검증 결과 (2026-05-15)

빌드 성공한 jar로 5가지 시나리오 검증.

### Test 매트릭스

| # | 시나리오 | Exit | Size | ANSI escape | 결과 |
|---|---|---|---|---|---|
| 1 | `--non-ansi -c "EXIT" > file` | 0 | 2731 B | **0개** | redirect + ANSI 제거 정상 |
| 2 | OpenJDK 21로 redirect (no flag) | 1 | 3970 B | n/a | **crash** (GraalVM 노이즈 아님 — 진짜 버그) |
| 3 | `\| pipe` (no flag) | 1 | crash | n/a | redirect와 동일 양상 |
| 4 | `--non-ansi \| pipe` | 0 | 38 lines | 0 | pipe도 플래그로 해결 |
| 5 | `--non-ansi -s -` (stdin script) | 0 | 2731 B | 0 | script 모드도 동일 |
| 6 | `--non-ansi --quiet -c "EXIT"` | 0 | **0 B** | 0 | banner 빠짐, 완전 깔끔 |

### 핵심 발견

1. **`--non-ansi`만으로 redirect와 pipe 둘 다 완전히 해결**
   → PR Patch 스코프 = **alias 추가만으로 충분** (Terminal 우회 로직 불필요)

2. **default 동작이 redirect/pipe 시 crash** — 이슈 원문의 "빈 파일"보다 심각
   ```
   java.lang.IllegalStateException: Unable to create a terminal
     at org.jline.terminal.TerminalBuilder.doBuild(TerminalBuilder.java:748)
     at org.projectnessie.nessie.cli.cli.NessieCliImpl.call(NessieCliImpl.java:189)
   ```
   원인: jline이 stdout이 TTY가 아닐 때 FFM/JNA/jansi provider 모두 로딩 실패.
   부수적 노이즈: jline FFM provider class 66.0(Java 22 컴파일) vs runtime 65.0(Java 21) — 본인 환경 한정 이슈로 보임. 본질은 그 위 IllegalStateException.

3. **`--non-ansi --quiet` 조합 = 완전 깔끔 출력** (실제 사용자가 redirect할 때 원하는 조합)

4. **`-c`, `-s`, pipe, redirect 모두 동일 메커니즘** — `dumbTerminal` 분기 한 곳이 다 해결

### PR description에 그대로 인용 가능

위 매트릭스 + 핵심 발견은 그대로 PR body에 넣으면 maintainer 리뷰가 빨라짐. "동작 변화 0, 사용성 개선만" 입증 완료.
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
- [x] **빌드 환경 해결** — SDKMAN + GraalVM 21 (21.0.11-graal) 설치, `:nessie-cli:shadowJar`로 빌드 성공
- [x] **로컬 빌드 성공** — `cli/cli/build/libs/nessie-cli-0.107.6-SNAPSHOT.jar`
- [x] **`--non-ansi` 단독 동작 검증** — redirect/pipe 둘 다 해결됨, ANSI escape 0개. PR 스코프 = alias 추가만으로 충분 확정
- [x] **추가 버그 발견** — default 동작이 redirect/pipe 시 `IllegalStateException` crash (PR description 자료)
- [x] **patch 작성** — `cli-stdout-plain` 브랜치, 5줄 변경 (+5, -2)
- [x] **재빌드 + 동작 검증** — `-P`, `--plain`, `--non-ansi` 모두 동등 동작 확인 (2731B, ANSI 0)
- [x] **DCO sign-off 커밋** — `a7c14609a`, `mj006648 <uckdekf@gmail.com>`
- [x] **fork에 push** — `origin/cli-stdout-plain`
- [x] **PR 제출** — [projectnessie/nessie#12425](https://github.com/projectnessie/nessie/pull/12425) (2026-05-15)
- [x] **maintainer 리뷰 응답 (2026-05-15)** — dimas-b: 이 변경은 OK하지만 본인 원래 의도(`PosixSysTerminal` 강제)와는 다름. 옵션 A(확장) / B(이거 머지 + 후속) 제안
- [x] **본인 답변 (2026-05-16)** — B 선택. 이 PR은 discoverability fix로 머지, `#10865` 열어둠. 머지 후 후속 PR (`--stdout`/`-S` + PosixSysTerminal) 작업 약속. [comment](https://github.com/projectnessie/nessie/pull/12425#issuecomment-4466091419)
- [ ] **CI flaky 무시** — `CI Test Quarkus` fail은 Keycloak OIDC startup race condition (본인 patch 무관). maintainer가 머지 시 알아서 retry
- [ ] PR #12425 머지 대기
- [ ] (필요 시) `--plain` / `-P` 옵션 파싱 unit test 추가
- [ ] PR merged → README "Merged" 표로 이동
- [ ] **후속 PR 작업 시작** — `PosixSysTerminal` 강제 + `--stdout`/`-S` 옵션 (이슈 #10865 진짜 close)

## 참고

- jline TerminalBuilder API: https://github.com/jline/jline3
- picocli `@Option` aliasing: 같은 필드에 여러 이름 부여 가능 (`names = {...}`)
- Nessie build-logic toolchain: `build-logic/build.gradle.kts:jvmToolchain { languageVersion=21 }`
- 보고자 @dimas-b 는 active maintainer라 리뷰 응답이 빠를 가능성 높음
- 이미 다른 Nessie PR (#12424, Cloud Object Storage docs) APPROVED 받음 → 같은 메인테이너와 신뢰 관계 진행 중
