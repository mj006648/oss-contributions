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

## 정찰 완료 — 진입 가능 후보

활성 후보표는 **2026년 6월 생성 이슈만** 유지한다. 룰: linked PR 0건 (`closedByPullRequestsReferences` + `CROSS_REFERENCED_EVENT` GraphQL 엄격 검증), assignee 0명, 사람 코멘트 0건을 기본으로 한다. 예외는 표의 상태 칸에 명시한다.

2026-06-23 재정찰 — 기존 2~5월 후보는 활성 후보표에서 제외하고 6월 생성 이슈로 교체. 최근 생성 이슈 중 이미 open PR이 붙은 항목은 회피 목록에 둔다. Polaris #4594는 intent comment를 게시해 `In Progress`로 이동.

| 우선 | 생성일 | 프로젝트 | 이슈 | 작업 종류 | 무엇 | 왜 필요 | 본인 강점 | 위험 | 상태 |
|---|---|---|---|---|---|---|---|---|---|
| 🟢 1 | 2026-06-03 | Nessie | [#12504](https://github.com/projectnessie/nessie/issues/12504) Iceberg REST `GET view`가 import view의 `representations` 누락 | 버그픽스 | metadata-location import된 view(Dremio류)에서 REST `GET view`가 `versions[].representations: []` 반환 — object storage엔 존재 | view 메타데이터 정합성. REST client가 view SQL representation을 읽지 못하는 문제 | Trident에서 Iceberg view/REST 다룸. 최근 Nessie 머지 4건으로 reviewer context 있음 | view metadata import 경로 재현 환경 필요 | CLEAN (linked PR 0, assignee 0, 사람 코멘트 0) / 2026-06-23 재검증 |
| 🟢 2 | 2026-06-02 | Polaris | [#4600](https://github.com/apache/polaris/issues/4600) JDBC `hasOverlappingSiblings` 회귀 테스트 보강 | 테스트/회귀 | NoSQL에는 overlap location coverage가 있는데 JDBC/H2 쪽 추가 시나리오가 부족 | storage location overlap bug 재발 방지 | S3 path normalization/Nessie S3 scheme PR 경험과 연결됨. 테스트 중심이라 진입 안전 | #4580 이후 remaining coverage라 기존 테스트 구조 파악 필요 | CLEAN (linked PR 0, assignee 0, 사람 코멘트 0) / 2026-06-23 재검증 |
| 🟢 3 | 2026-06-17 | Polaris | [#4802](https://github.com/apache/polaris/issues/4802) HTTP server request duration histogram buckets | 운영/관측성 | Micrometer/Prometheus HTTP timer가 `_bucket` 시계열을 내보내지 않아 `histogram_quantile` 기반 p95/p99 대시보드·알림이 불가 | 운영 환경에서 평균/최대만으로는 latency SLO 판단이 어려움 | TwinX/Prometheus/Grafana 운영 경험. Micrometer 설정 기반이면 scope 비교적 작음 | Quarkus/Micrometer 설정 방식 합의 필요 | CLEAN (linked PR 0, assignee 0, 사람 코멘트 0) / 2026-06-23 재검증 |
| 🟡 4 | 2026-06-03 | Nessie | [#12503](https://github.com/projectnessie/nessie/issues/12503) Helm chart OCI artifact 퍼블리시 | 인프라/Release | deprecated index.yaml 대신 OCI artifact로 Helm chart 퍼블리시 요청 | 현대적 Helm 소비 방식 지원 | TwinX Helm/OCI 운영 경험 직결 | release workflow 변경이라 maintainer 디자인 합의 선행 | CLEAN (linked PR 0, assignee 0, 사람 코멘트 0) / 2026-06-23 재검증 |
| 🟡 5 | 2026-06-08 | Polaris | [#4658](https://github.com/apache/polaris/issues/4658) table notification CREATE/UPDATE concurrent modification retry | 버그픽스 | external table notification 중 동시 수정이 있으면 CREATE/UPDATE가 retry 없이 실패 | concurrent metadata update 안정성 | Polaris REST/catalog 운영 관심사와 맞음. UPDATE retry만 좁히면 scope 관리 가능 | CREATE→UPDATE race까지 포함하면 커짐. retry utility/pattern 확인 필요 | CLEAN (linked PR 0, assignee 0, 사람 코멘트 0) / 2026-06-23 재검증 |
| 🟡 6 | 2026-06-11 | Iceberg | [#16767](https://github.com/apache/iceberg/issues/16767) unpartitioned table custom hash distribution columns | Spark 기능 | unpartitioned table에서 `write.distribution-mode=hash`가 `NONE`으로 내려가 file count 제어가 어려움 | streaming/unpartitioned write file sizing 제어 | Spark/Iceberg 운영 이슈라 연구 스택과 맞음 | 작성자가 독립 기여 가능 체크. feature scope 크고 design review 필요 | CLEAN but 원작성자 기여 의향 있음 / 2026-06-23 재검증 |
| 🟡 7 | 2026-06-02 | Iceberg | [#16661](https://github.com/apache/iceberg/issues/16661) failed scans/commits를 `MetricsReporter`에 보고 | Core/관측성 | 현재 `MetricsReporter`는 성공한 scan/commit만 관측, 실패율·conflict·retry exhaustion 관측 불가 | 운영 관측성 및 RESTMetricsReporter 확장 가능성 | 관측성/운영 경험과 맞음 | 새 public report type 여부 등 API 설계 합의 필요. 작성자가 독립 기여 가능 체크 | CLEAN but design-input 필요 / 2026-06-23 재검증 |
| ⚪ 8 | 2026-06-09 | Iceberg | [#16741](https://github.com/apache/iceberg/issues/16741) REST staged create-or-replace transaction primitive | REST Catalog 기능 | non-Java REST client가 Java `createOrReplaceTransaction()`과 동등한 safe primitive를 갖지 못함 | DuckDB/C++ 등 non-Java client의 atomic create-or-replace 지원 | REST catalog/Trident 연구와 잘 맞음 | REST spec/API 설계라 매우 큼. 첫 Iceberg 본체 PR로는 부담 | CLEAN but 대형 design issue / 2026-06-23 재검증 |
| ⚪ 9 | 2026-06-03 | Iceberg | [#16675](https://github.com/apache/iceberg/issues/16675) Spark write-time Parquet footer aggregate metrics event | Proposal/관측성 | wide table의 physical/storage metrics를 manifest에 저장하지 않고 commit-time event로 emit | metadata bloat 없이 observability 확보 | 운영 관측성 관심사와 맞음 | proposal 라벨. Spark write path + event framework 설계가 커서 장기 관망 | CLEAN but proposal 단계 / 2026-06-23 재검증 |

## Merged

| 프로젝트 | PR | 머지일 | 비고 |
|---------|----|--------|------|
| Nessie | [#12432](https://github.com/projectnessie/nessie/pull/12432) Normalize S3 scheme in IcebergConfigurer writeable derivation (issue #12426) | 2026-06-19 | dimas-b 6/16 @snazy 의견 요청 → snazy 6/19 LGTM APPROVED 직후 머지. `s3a://`/`s3n://` table metadata location을 `s3://` warehouse prefix와 비교할 때 normalize해서 S3 signer `writeable[]` 누락을 수정. 로컬 검증: `:nessie-catalog-service-rest:spotlessCheck`, `:nessie-catalog-service-rest:test --tests org.projectnessie.catalog.service.rest.TestIcebergConfigurer`. **4번째 Nessie 머지, 5번째 lakehouse upstream 머지 기여** |
| Polaris | [#4451](https://github.com/apache/polaris/pull/4451) docs: add production configuration pages for AWS S3 and Azure Blob storage (issue #1325) | 2026-05-27 | dimas-b + flyrain 2-round 리뷰 반영 후 머지. AWS S3 + Azure Blob 두 production config 페이지 신규 추가. flyrain의 "3개 IAM identity 다뤄달라" 요청 반영해 IAM identities overview + Polaris service identity 섹션 추가. **첫 Polaris 머지, 4번째 Apache 머지 기여** |
| Nessie | [#12431](https://github.com/projectnessie/nessie/pull/12431) CLI `--stdout`/`-S` for stream-backed terminal (issue #10865) | 2026-05-26 | dimas-b APPROVED + merge. `system(false).streams(...).type("dumb")` 로 redirected stdout/pipe 시 PTY 우회. 5/25 1차 APPROVED with 2 nits → 5/26 description 다듬어 `e38ddd30` push → dimas-b 재APPROVED → 17분 뒤 머지. 3번째 머지 기여 |
| Nessie | [#12425](https://github.com/projectnessie/nessie/pull/12425) CLI `--plain`/`-P` alias (issue #10865) | 2026-05-20 | dimas-b APPROVED + merge. **후속 작업 필요**: `--stdout`/`-S` + `PosixSysTerminal` 강제 — 이슈 #10865는 OPEN 유지 |
| Nessie | [#12424](https://github.com/projectnessie/nessie/pull/12424) Cloud Object Storage 일관성 문서 (issue #5349) | 2026-05-20 | dimas-b + @snazy APPROVED. **첫 머지 기여** |

## 회피 기준

긴 회피 후보 목록은 유지하지 않는다. 후보 재정찰 시 아래 기준에 걸리면 활성 후보표에 올리지 않는다.

| 제외 기준 | 의미 |
|---|---|
| open linked PR 있음 | 이미 다른 사람이 작업 중이므로 가로채지 않음 |
| assignee 또는 명확한 작업자 있음 | 댓글/assigned/maintainer 요청으로 소유자가 보이면 회피 |
| maintainer가 design discussion 요청 | mailing list·proposal·큰 API 설계 단계는 보류 |
| 이미 해결·중복·stale 성격 | PR effort 대신 기록 없이 제외 |
| lakehouse 집중 밖 | ArgoCD/Kyverno 등 운영 중 발견 이슈는 등록/코멘트만 하고 PR effort는 제한 |

## Roadmap — 진입 우선순위

활성 목표는 GitHub 배지 수집보다 **lakehouse 핵심 스택에서 작고 확실한 PR을 꾸준히 머지하는 것**이다.

| 우선 | 영역 | 현재 상태 | 다음 액션 |
|---|---|---|---|
| 1 | Apache Polaris | #4451 머지, #4594 intent comment 게시 | #4594 구현 후 필요하면 #4600/#4802 검토 |
| 2 | Project Nessie | #12424/#12425/#12431/#12432 머지 | 최근 후보 #12504/#12503 중 작게 끝낼 수 있는 것만 선별 |
| 3 | Apache Iceberg / PyIceberg | 아직 코드 PR 미진입 | 6월 생성 이슈 중 linked PR 없는 것만 재정찰 |
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
- master-thesis — 논문 원고 (local)
