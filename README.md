# OSS Contributions Tracker

> Last updated: 2026-06-24

석사 연구(GIST AI, Apache Iceberg 기반 Cloud-Native Trident Lakehouse) 수행 중 발견한 upstream 개선점을 정리하고, 이슈 등록부터 PR 머지까지의 전 과정을 추적한다.

## 기여 집중 전략

**Lakehouse 핵심 스택에서 작고 확실한 PR을 꾸준히 머지하는 것**을 우선한다. Kubernetes SIGs는 클러스터 운영 경험을 살릴 수 있는 보조 진입 트랙으로 둔다.

| 영역 | 현재 상태 | 다음 액션 |
|---|---|---|
| Apache Polaris | #4451 머지, #4594 의도 댓글 게시 | #4594 진행 후 #4600/#4802 중 작은 것 검토 |
| Project Nessie | #12424/#12425/#12431/#12432/#12602 머지 | #12503 검토 |
| Apache Iceberg / PyIceberg | 아직 코드 PR 미진입 | linked PR 없는 작고 명확한 이슈만 재정찰 |
| Kubernetes SIGs | 후보 4건 선별 | `kindnet` #113 또는 `mcp-lifecycle-operator` #135부터 검토 |
| Personal research repos | Trident-Lakehouse / Experiments / thesis | upstream 기여와 연결되는 재현·검증 자료 정리 |

## In Progress

| 프로젝트 | 이슈/PR | 상태 | 시작일 | 비고 |
|---------|---------|------|--------|------|
| Polaris | [#4594](https://github.com/apache/polaris/issues/4594) `InMemoryBufferEventListener`에서 불필요한 `MetricsPersistence` 제거 | 의도 댓글 게시 | 2026-06-23 | [comment](https://github.com/apache/polaris/issues/4594#issuecomment-4775931438) 게시. 다음 단계: wiring 추적 → 불필요한 `MetricsPersistence` setup 제거 → 관련 테스트 업데이트. |

## 정찰 완료 — 진입 가능 후보

활성 후보표는 지금 들어가도 충돌 가능성이 낮은 이슈만 최대 10개로 유지한다. 기본 기준은 linked PR 없음, assignee 없음, 명확한 작업자 없음이다. Kubernetes SIGs 후보는 운영 경험과 맞는 항목만 보조 트랙으로 둔다.

| 우선 | 생성일 | 프로젝트 | 이슈 | 성격 | 다음 액션 / 리스크 |
|---|---|---|---|---|---|
| 🟢 1 | 2026-06-02 | Polaris | [#4600](https://github.com/apache/polaris/issues/4600) JDBC `hasOverlappingSiblings` 회귀 테스트 | 테스트/회귀 | 기존 JDBC/H2 테스트 구조 파악 후 NoSQL overlap 케이스를 일부 이식 |
| 🟢 2 | 2026-06-17 | Polaris | [#4802](https://github.com/apache/polaris/issues/4802) HTTP request duration histogram buckets | 운영/관측성 | Quarkus/Micrometer 설정 방식 확인 필요. 설정 옵션/문서까지 같이 봐야 함 |
| 🟢 3 | 2026-06-03 | Nessie | [#12503](https://github.com/projectnessie/nessie/issues/12503) Helm chart OCI artifact 퍼블리시 | 인프라/Release | release workflow 변경이라 maintainer 방향 확인 필요 |
| 🟢 4 | 2026-06-16 | Kubernetes SIGs / kindnet | [#113](https://github.com/kubernetes-sigs/kindnet/issues/113) CRI runtime API upgrade build break | Kubernetes/Go | 닫힌 PR #105의 수정 방향 재확인 후 `remote.NewRemoteRuntimeService` 인자 업데이트 |
| 🟢 5 | 2026-04-29 | Kubernetes SIGs / mcp-lifecycle-operator | [#135](https://github.com/kubernetes-sigs/mcp-lifecycle-operator/issues/135) Helm installation documentation | 문서/Helm | chart 설치 흐름 확인 후 quickstart, values, 검증 명령 정리 |
| 🟡 6 | 2026-06-08 | Polaris | [#4658](https://github.com/apache/polaris/issues/4658) table notification concurrent modification retry | 버그픽스 | UPDATE retry만 좁히면 가능. CREATE race까지 포함하면 커짐 |
| 🟡 7 | 2026-05-14 | Kubernetes SIGs / mcp-lifecycle-operator | [#177](https://github.com/kubernetes-sigs/mcp-lifecycle-operator/issues/177) E2E test coverage instrumentation | 테스트/CI | 현재 e2e runner 확인 후 coverage flag/artifact 범위를 작게 잡아야 함 |
| 🟡 8 | 2026-05-27 | Kubernetes SIGs / cluster-api-provider-aws | [#6033](https://github.com/kubernetes-sigs/cluster-api-provider-aws/issues/6033) e2e에서 `kindest/node` prebuilt image 대신 kind node image build | E2E/infra | e2e 영향이 커서 로컬 재현과 기존 kind image build path 확인이 먼저 |
| 🟡 9 | 2026-06-11 | Iceberg | [#16767](https://github.com/apache/iceberg/issues/16767) unpartitioned table hash distribution columns | Spark 기능 | 기능 범위가 커서 design review 필요. 원작성자 기여 의향도 확인됨 |
| 🟡 10 | 2026-06-02 | Iceberg | [#16661](https://github.com/apache/iceberg/issues/16661) failed scan/commit metrics reporting | 관측성 | public report type/API 설계 확인 필요 |

## Merged

| 프로젝트 | PR | 머지일 | 비고 |
|---------|----|--------|------|
| Nessie | [#12602](https://github.com/projectnessie/nessie/pull/12602) Preserve SQL representations when importing Iceberg views (issue #12504) | 2026-06-23 | snazy LGTM APPROVED 후 머지. metadata-location import 변환 경로에서 `currentVersion.representations()`를 Nessie snapshot에 보존해 Iceberg REST `GET view`의 `versions[].representations` 누락을 수정. 로컬 검증: `:nessie-catalog-format-iceberg:test --tests org.projectnessie.catalog.formats.iceberg.nessie.TestNessieModelIceberg.icebergViewSnapshotToNessiePreservesRepresentations`, `:nessie-catalog-format-iceberg:test --tests org.projectnessie.catalog.formats.iceberg.nessie.TestNessieModelIceberg`, `:nessie-catalog-format-iceberg:spotlessCheck`. **5번째 Nessie 머지, 6번째 Lakehouse upstream 머지 기여** |
| Nessie | [#12432](https://github.com/projectnessie/nessie/pull/12432) Normalize S3 scheme in IcebergConfigurer writeable derivation (issue #12426) | 2026-06-19 | dimas-b 6/16 @snazy 의견 요청 → snazy 6/19 LGTM APPROVED 직후 머지. `s3a://`/`s3n://` table metadata location을 `s3://` warehouse prefix와 비교할 때 normalize해서 S3 signer `writeable[]` 누락을 수정. 로컬 검증: `:nessie-catalog-service-rest:spotlessCheck`, `:nessie-catalog-service-rest:test --tests org.projectnessie.catalog.service.rest.TestIcebergConfigurer`. **4번째 Nessie 머지, 5번째 Lakehouse upstream 머지 기여** |
| Polaris | [#4451](https://github.com/apache/polaris/pull/4451) docs: add production configuration pages for AWS S3 and Azure Blob storage (issue #1325) | 2026-05-27 | dimas-b + flyrain 2-round 리뷰 반영 후 머지. AWS S3 + Azure Blob 두 production config 페이지 신규 추가. flyrain의 "3개 IAM identity 다뤄달라" 요청 반영해 IAM identities overview + Polaris service identity 섹션 추가. **첫 Polaris 머지, 첫 Apache org 머지 기여** |
| Nessie | [#12431](https://github.com/projectnessie/nessie/pull/12431) CLI `--stdout`/`-S` for stream-backed terminal (issue #10865) | 2026-05-26 | dimas-b APPROVED + merge. `system(false).streams(...).type("dumb")` 로 redirected stdout/pipe 시 PTY 우회. 5/25 1차 APPROVED with 2 nits → 5/26 description 다듬어 `e38ddd30` push → dimas-b 재APPROVED → 17분 뒤 머지. 3번째 머지 기여 |
| Nessie | [#12425](https://github.com/projectnessie/nessie/pull/12425) CLI `--plain`/`-P` alias (issue #10865) | 2026-05-20 | dimas-b APPROVED + merge. **후속 작업 필요**: `--stdout`/`-S` + `PosixSysTerminal` 강제 — 이슈 #10865는 OPEN 유지 |
| Nessie | [#12424](https://github.com/projectnessie/nessie/pull/12424) Cloud Object Storage 일관성 문서 (issue #5349) | 2026-05-20 | dimas-b + @snazy APPROVED. **첫 머지 기여** |

## 운영 메모

### 진입 절차

1. 후보 이슈의 assignee, 댓글, linked PR을 `gh`/GraphQL로 재검증한다.
2. 충돌 가능성이 낮으면 의도 댓글 또는 작은 PR로 진입한다.
3. PR은 해당 이슈만 고치도록 작게 유지한다.
4. DCO/CLA, 테스트, 리뷰 피드백을 확인한다.
5. 머지/종결 결과만 이 README에 남긴다.

### 응답 모니터링

```bash
./scripts/check-responses.sh
./scripts/check-responses.sh add <owner/repo> <issueNumber> <shortName>
```

- 새 활동은 `<-- NEW`로 표시된다.
- 상태 파일은 `scripts/.last-check`에 저장된다. (`gitignore`)

### 기록 원칙

- 이슈마다 `issue-<번호>-<짧은제목>/` 폴더를 둔다.
- PR/이슈 초안은 `pr-draft.md`, `issue-draft.md`로 남긴다.
- 버그 이슈는 가능한 한 재현 스크립트나 검증 로그를 남긴다.
- 리뷰 피드백과 거절 사유는 `learnings/`에 누적한다.

### 의도 댓글 원칙

- 첫 댓글은 인사말 없이 본론부터 짧게 쓴다.
- 코드·재현 근거를 1~2줄 넣어 실제로 확인했다는 신호를 준다.
- `If nobody is already working on this, I'd like to take a look.`처럼 선점보다 확인 톤을 쓴다.
- 첫 댓글에서 maintainer를 직접 멘션하거나 assign을 요청하지 않는다.
- 설계가 큰 이슈는 PR 전에 방향을 확인하고, 작은 버그는 테스트 포함 PR로 바로 보여준다.

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
