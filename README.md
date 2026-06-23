# OSS Contributions Tracker

> Last updated: 2026-06-23

석사 연구(GIST AI, Apache Iceberg 기반 Cloud-Native Trident Lakehouse) 수행 중 발견한 upstream 개선점을 정리하고, 이슈 등록부터 PR 머지까지의 전 과정을 추적한다.

## 기여 집중 전략

PR effort는 lakehouse 핵심 스택에 집중한다:

- **Apache Iceberg** — 테이블 포맷 (apache/iceberg)
- **PyIceberg** — Iceberg Python 구현체 (apache/iceberg-python)
- **Project Nessie** — Git-style 카탈로그 (projectnessie/nessie)
- **Apache Polaris** — REST 카탈로그 (apache/polaris)

위 프로젝트들은 reviewer 풀이 겹치고, 본 연구의 데이터 평면을 그대로 구성한다. 단일 도메인 집중을 통해 Apache committer 진입 조건(단일 프로젝트 깊이)을 충족하는 것이 중기 목표.

클러스터 운영(rook-ceph, cilium, kyverno, argocd 등) 중 발견한 이슈는 upstream에 등록만 하고 PR effort는 투입하지 않는다.

## In Progress

| 프로젝트 | 이슈/PR | 상태 | 시작일 | 비고 |
|---------|---------|------|--------|------|
| Polaris | [#4594](https://github.com/apache/polaris/issues/4594) `InMemoryBufferEventListener`에서 불필요한 `MetricsPersistence` 제거 | intent comment 게시 | 2026-06-23 | [comment](https://github.com/apache/polaris/issues/4594#issuecomment-4775931438) 게시. 다음 단계: wiring 추적 → 불필요한 `MetricsPersistence` setup 제거 → 관련 테스트 업데이트. |
| Nessie | [#12602](https://github.com/projectnessie/nessie/pull/12602) Iceberg view import 시 SQL representation 보존 ([#12504](https://github.com/projectnessie/nessie/issues/12504)) | PR open | 2026-06-23 | metadata-location import 변환 경로에서 `currentVersion.representations()`를 Nessie snapshot에 보존. 관련 단위 테스트 + `spotlessCheck` 통과. |

## 정찰 완료 — 진입 가능 후보

활성 후보표는 지금 들어가도 충돌 가능성이 낮은 이슈만 둔다. 기본 기준은 linked PR 없음, assignee 없음, 명확한 작업자 없음이다. 설계 논의가 크거나 이미 해결·중복으로 보이는 이슈는 제외하고, 남길 만한 주의점은 다음 액션에 짧게 적는다.

| 우선 | 생성일 | 프로젝트 | 이슈 | 성격 | 다음 액션 / 리스크 |
|---|---|---|---|---|---|
| 🟢 1 | 2026-06-02 | Polaris | [#4600](https://github.com/apache/polaris/issues/4600) JDBC `hasOverlappingSiblings` 회귀 테스트 | 테스트/회귀 | 기존 JDBC/H2 테스트 구조 파악 후 NoSQL overlap 케이스를 일부 이식 |
| 🟢 2 | 2026-06-17 | Polaris | [#4802](https://github.com/apache/polaris/issues/4802) HTTP request duration histogram buckets | 운영/관측성 | Quarkus/Micrometer 설정 방식 확인 필요. 설정 옵션/문서까지 같이 봐야 함 |
| 🟢 3 | 2026-06-03 | Nessie | [#12503](https://github.com/projectnessie/nessie/issues/12503) Helm chart OCI artifact 퍼블리시 | 인프라/Release | release workflow 변경이라 maintainer 방향 확인 필요 |
| 🟡 4 | 2026-06-08 | Polaris | [#4658](https://github.com/apache/polaris/issues/4658) table notification concurrent modification retry | 버그픽스 | UPDATE retry만 좁히면 가능. CREATE race까지 포함하면 커짐 |
| 🟡 5 | 2026-06-11 | Iceberg | [#16767](https://github.com/apache/iceberg/issues/16767) unpartitioned table hash distribution columns | Spark 기능 | 기능 범위가 커서 design review 필요. 원작성자 기여 의향도 확인됨 |
| 🟡 6 | 2026-06-02 | Iceberg | [#16661](https://github.com/apache/iceberg/issues/16661) failed scan/commit metrics reporting | 관측성 | public report type/API 설계 확인 필요 |
| ⚪ 7 | 2026-06-09 | Iceberg | [#16741](https://github.com/apache/iceberg/issues/16741) REST staged create-or-replace transaction | REST Catalog | REST spec/API 설계라 첫 Iceberg 본체 PR로는 큼 |
| ⚪ 8 | 2026-06-03 | Iceberg | [#16675](https://github.com/apache/iceberg/issues/16675) Parquet footer aggregate metrics event | 관측성/Proposal | Spark write path + event framework 설계 필요 |

## Merged

| 프로젝트 | PR | 머지일 | 비고 |
|---------|----|--------|------|
| Nessie | [#12432](https://github.com/projectnessie/nessie/pull/12432) Normalize S3 scheme in IcebergConfigurer writeable derivation (issue #12426) | 2026-06-19 | dimas-b 6/16 @snazy 의견 요청 → snazy 6/19 LGTM APPROVED 직후 머지. `s3a://`/`s3n://` table metadata location을 `s3://` warehouse prefix와 비교할 때 normalize해서 S3 signer `writeable[]` 누락을 수정. 로컬 검증: `:nessie-catalog-service-rest:spotlessCheck`, `:nessie-catalog-service-rest:test --tests org.projectnessie.catalog.service.rest.TestIcebergConfigurer`. **4번째 Nessie 머지, 5번째 lakehouse upstream 머지 기여** |
| Polaris | [#4451](https://github.com/apache/polaris/pull/4451) docs: add production configuration pages for AWS S3 and Azure Blob storage (issue #1325) | 2026-05-27 | dimas-b + flyrain 2-round 리뷰 반영 후 머지. AWS S3 + Azure Blob 두 production config 페이지 신규 추가. flyrain의 "3개 IAM identity 다뤄달라" 요청 반영해 IAM identities overview + Polaris service identity 섹션 추가. **첫 Polaris 머지, 4번째 Apache 머지 기여** |
| Nessie | [#12431](https://github.com/projectnessie/nessie/pull/12431) CLI `--stdout`/`-S` for stream-backed terminal (issue #10865) | 2026-05-26 | dimas-b APPROVED + merge. `system(false).streams(...).type("dumb")` 로 redirected stdout/pipe 시 PTY 우회. 5/25 1차 APPROVED with 2 nits → 5/26 description 다듬어 `e38ddd30` push → dimas-b 재APPROVED → 17분 뒤 머지. 3번째 머지 기여 |
| Nessie | [#12425](https://github.com/projectnessie/nessie/pull/12425) CLI `--plain`/`-P` alias (issue #10865) | 2026-05-20 | dimas-b APPROVED + merge. **후속 작업 필요**: `--stdout`/`-S` + `PosixSysTerminal` 강제 — 이슈 #10865는 OPEN 유지 |
| Nessie | [#12424](https://github.com/projectnessie/nessie/pull/12424) Cloud Object Storage 일관성 문서 (issue #5349) | 2026-05-20 | dimas-b + @snazy APPROVED. **첫 머지 기여** |

## Roadmap — 진입 우선순위

활성 목표는 GitHub 배지 수집보다 **lakehouse 핵심 스택에서 작고 확실한 PR을 꾸준히 머지하는 것**이다.

| 우선 | 영역 | 현재 상태 | 다음 액션 |
|---|---|---|---|
| 1 | Apache Polaris | #4451 머지, #4594 intent comment 게시 | #4594 구현 후 필요하면 #4600/#4802 검토 |
| 2 | Project Nessie | #12424/#12425/#12431/#12432 머지, #12602 open | #12602 리뷰 대응 후 #12503 검토 |
| 3 | Apache Iceberg / PyIceberg | 아직 코드 PR 미진입 | 작고 명확한 이슈만 재정찰 |
| 4 | Kubernetes/infra orgs | 적극 정찰 중단 | 실제 운영 중 직접 발견한 버그만 이슈/PR 검토 |
| 5 | 기타 orgs | 배지 목적 정찰 중단 | thesis/lakehouse와 직접 연결될 때만 진입 |

### 진입 워크플로우

1. 후보 이슈의 assignee, 댓글, linked PR을 GraphQL/`gh`로 재검증한다.
2. 아무도 작업 중이 아니면 intent comment를 짧게 남긴다.
3. PR은 해당 이슈만 고치도록 작게 유지한다.
4. DCO/CLA, 테스트, 리뷰 피드백을 확인한다.
5. 머지/종결 결과만 이 README에 남긴다.

## 폴더 구조

```
oss-contributions/
├── README.md                     현재 파일, 전체 대시보드
├── projects/                     프로젝트별 작업 공간
│   ├── nessie/
│   │   ├── README.md             Nessie 활동 요약
│   │   ├── issue-10865-cli-stdout/
│   │   └── issue-5349-docs/
│   ├── iceberg/
│   │   └── README.md
│   ├── pyiceberg/
│   │   └── README.md
│   ├── polaris/
│   │   ├── README.md
│   │   └── issue-1325-storage-docs/
│   ├── argocd/
│   │   ├── README.md
│   │   └── issue-18198-request-timeout/
│   └── kubernetes/
├── templates/                    재사용 템플릿
│   ├── pr-description.md
│   ├── issue-report.md
│   └── dco-checklist.md
├── learnings/                    학습/회고 노트
│   ├── git-workflows.md
│   ├── cla-vs-dco.md
│   └── code-review-feedback.md
└── thesis-evidence/              논문 인용용 정리
    └── contributions-for-paper.md
```

---

## 응답 모니터링

`scripts/check-responses.sh`를 실행하면 추적 중인 모든 이슈의 마지막 코멘트 timestamp를 한 번에 확인할 수 있다. 이전 실행과 비교해 새 활동이 있는 이슈는 `<-- NEW`로 표시.

```bash
./scripts/check-responses.sh
```

새 이슈를 추적 목록에 추가하려면 스크립트 상단 `TRACKED=(...)` 배열에 한 줄 추가 (또는 헬퍼 사용):

```bash
./scripts/check-responses.sh add <owner/repo> <issueNumber> <shortName>
# 예시: ./scripts/check-responses.sh add kyverno/kyverno 16103 kyverno-certmanager
```

상태 파일 위치: `scripts/.last-check` (gitignore됨)

## 운영 원칙

1. 이슈마다 폴더 하나 — `issue-<번호>-<짧은제목>/` 형식
2. PR/이슈 본문 초안은 git으로 버전 관리 — `pr-draft.md`, `issue-draft.md`
3. 재현 스크립트 첨부 — 버그 이슈는 `reproduce.sh` 권장
4. 피드백 즉시 기록 — 받은 리뷰 코멘트를 `learnings/code-review-feedback.md`에 누적
5. 거절도 기록 — 왜 거절됐는지가 가장 큰 학습 자산

## 의도 코멘트 (intent comment) 원칙

새 이슈에 처음 들어갈 때 따르는 OSS etiquette. Nessie/Apache 양쪽에서 검증된 패턴.

1. **인사말 생략** — `Hi @user` 같은 도입부 없이 본론부터.
2. **재현/이해 증거 1~2줄** — 본인이 코드 읽었다는 신호. 파일/라인/버전 명시.
3. **"가져가도 되나" 명시** — `If nobody is on this, I'd like to take it on.` 류 한 줄 필수.
4. **scope bullet** — maintainer가 yes/no 답하기 쉽게 3~4개로.
5. **maintainer 직접 멘션 금지** — 첫 코멘트에서 `@maintainer` 호출은 결례. 디자인 토론은 PR에서.
6. **디자인 분기점은 PR로 미루기** — 첫 코멘트에서 "A vs B 중 뭐가 좋나요?"는 부담. "A로 가려 한다, 리뷰에서 조정 환영"까지만.
7. **assign 요청 금지** — Apache/Nessie 모두 비권장. 코멘트로 의도만 표명.
8. **답 없으면 3~7일 기다림** — 강행하지 말 것. Nessie는 빠른 편, Apache는 며칠 여유.
9. **DCO/CLA 사전 확인** — Nessie는 DCO sign-off, Apache는 ICLA.
10. **assign 안 받아도 fork+PR 올려도 됨** — 단 본인 시간 risk 감수. 의도 코멘트 후 답 받고 진행하는 게 안전.

---

## 관련 저장소

### SmartX-Team (조직, GIST NetAI Lab)

- [ScaleX-POD](https://github.com/SmartX-Team/ScaleX-POD) — 클라우드 네이티브 디지털 트윈 멀티클러스터 인프라 본체
- [TwinX-Ops](https://github.com/SmartX-Team/TwinX-Ops) — ArgoCD GitOps / 배포 매니페스트

### Personal

- [Trident-Lakehouse](https://github.com/mj006648/Trident-Lakehouse) — Apache Iceberg 기반 Cloud-Native Trident Lakehouse 본체
- [Trident-Lakehouse-Experiments](https://github.com/mj006648/Trident-Lakehouse-Experiments) — Lakehouse 실험/검증 코드
- [Trident-Portal](https://github.com/mj006648/Trident-Portal) — 석사 연구 포털 (Next.js + FastAPI)
- [Trident-Twin](https://github.com/mj006648/Trident-Twin) — 3D Omniverse Twin
- [master-thesis](https://github.com/mj006648/master-thesis) — 논문 원고
