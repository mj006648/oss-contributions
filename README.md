# OSS Contributions Tracker

> Last updated: 2026-07-19

석사 연구(GIST AI, Apache Iceberg 기반 Cloud-Native Trident Lakehouse) 수행 중 발견한 upstream 개선점을 정리하고, 이슈 등록부터 PR 머지까지의 전 과정을 추적한다.

## 기여 집중 전략

**Lakehouse 핵심 스택에서 작고 확실한 PR을 꾸준히 머지하는 것**을 우선한다. Kubernetes SIGs는 클러스터 운영 경험을 살릴 수 있는 보조 진입 트랙으로 둔다.

| 영역 | 현재 상태 | 다음 액션 |
|---|---|---|
| Apache Polaris | #4451, #4877 머지 | 즉시 진입 후보 없음. #4600/#4658 stale 해제 가치부터 확인하고 신규 이슈를 계속 정찰 |
| Project Nessie | #12424/#12425/#12431/#12432/#12602/#12613 머지 | #12130을 current `main`에서 재현하고, #12503은 release workflow 방향 댓글부터 게시 |
| Apache Iceberg | 아직 코드 PR 미진입 | #17139 문서 수정 우선 검토, #17140은 Flink 테스트 범위 확인 후 진입 판단 |
| Kubernetes SIGs | agent-sandbox #1029/#1033, LWS #895/#896 머지 | 새 구현 후보는 Lakehouse 우선순위와 충돌하지 않는 범위에서 재정찰 |
| Personal research repos | Trident-Lakehouse / Experiments / thesis | upstream 기여와 연결되는 재현·검증 자료 정리 |

## In Progress

현재 진행 중인 PR 없음.

## Issues

직접 발견·재현해 upstream에 등록했고 maintainer triage가 붙은 이슈만 기록한다. 단순 후보나 댓글 참여는 제외한다.

| 프로젝트 | 이슈 | 상태 | 등록일 | 비고 |
|---------|------|------|--------|------|
| Kyverno | [#16103](https://github.com/kyverno/kyverno/issues/16103) cert-manager delegation 시 TLS Secret ping-pong | open · `helm` · `release-high` · assigned to yashrajshuklaaa · milestone 1.19.0 | 2026-05-14 | chart 3.7.1/3.7.2에서 `admissionController.certManager.enabled=true` 재현. cert-manager와 in-process certmanager controller가 같은 TLS Secret을 번갈아 갱신하는 문제 보고. 2026-06-25 yashrajshuklaaa가 `/assign`, 2026-07-08 `Kyverno Release 1.19.0` milestone 지정. 다른 사용자도 동일 증상과 backport 필요성을 댓글로 확인. 다음 단계: upstream fix/PR 발생 시 실제 클러스터에서 검증 지원 가능. |

## Merged

| 프로젝트 | PR | 머지일 | 비고 |
|---------|----|--------|------|
| Kubernetes SIGs / LWS | [#896](https://github.com/kubernetes-sigs/lws/pull/896) Propagate LWS metadata to StatefulSets (issue #895) | 2026-07-16 | LeaderWorkerSet의 사용자 labels/annotations를 생성되는 leader·worker StatefulSet에 전파하되 controller-managed metadata가 우선하도록 구현하고 회귀 테스트 추가. operational metadata visibility use case 설명 후 ahg-g `/approve`/`/lgtm`, 최신 main rebase, GitHub Actions와 Prow unit/integration/e2e/verify checks 및 Tide 통과로 머지. issue #895 자동 close. **2번째 Kubernetes SIGs 머지, 전체 10번째 upstream PR 머지 기여** |
| Kubernetes SIGs / agent-sandbox | [#1033](https://github.com/kubernetes-sigs/agent-sandbox/pull/1033) Remove `use_pod_ip` from Python sandbox clients (issue #1029) | 2026-07-10 | SHRUTI6991의 방향 제안에 따라 `use_pod_ip` toggle을 제거하고 현재 pod-IP-first/DNS-fallback 동작에 맞춰 sync/async clients, README, examples, site docs, unit tests 정리. aditya-shantanu follow-up review 반영 후 approve, vicentefb `/lgtm`/approval, Prow unit/e2e/benchmark/autogen checks 및 tide 통과. issue #1029 completed close. **첫 Kubernetes SIGs 머지, 전체 9번째 upstream PR 머지 기여** |
| Polaris | [#4877](https://github.com/apache/polaris/pull/4877) Avoid metrics persistence setup for in-memory event buffering (issue #4594) | 2026-06-30 | dimas-b/ayushtkn approval 후 머지. #4866으로 main에 반영된 production code path와 충돌을 rebase로 정리하고, `InMemoryBufferEventListener`가 `MetricsPersistence`를 생성하지 않는 regression coverage만 유지. upstream 전체 CI 통과. #4879는 #4878 선행 머지로 superseded되어 closed. **2번째 Polaris 머지, 8번째 Lakehouse upstream 머지 기여** |
| Nessie | [#12613](https://github.com/projectnessie/nessie/pull/12613) Restore Prometheus metrics endpoint (issue #12398) | 2026-06-24 | snazy LGTM APPROVED 후 머지, issue #12398 close. 공개 이미지 0.107.5/0.107.9/0.108.0/unstable 404 재현, 0.107.4 200 확인. runtime Prometheus registry dependency 복구와 `server.port` metric tag 충돌 정리로 `/q/metrics`를 다시 노출. upstream CI `CI Code Checks et al`, `CI Test`, `CI Test Quarkus`, `CI intTest Quarkus Server` 통과. 로컬 검증: `:nessie-quarkus:test --tests org.projectnessie.server.TestMetricsTags --tests org.projectnessie.server.TestMetricsDisabled`, `:nessie-quarkus:quarkusBuild`, `:nessie-quarkus:generateLicenseReport`, `:nessie-quarkus:codeChecks`. **6번째 Nessie 머지, 7번째 Lakehouse upstream 머지 기여** |
| Nessie | [#12602](https://github.com/projectnessie/nessie/pull/12602) Preserve SQL representations when importing Iceberg views (issue #12504) | 2026-06-23 | snazy LGTM APPROVED 후 머지. metadata-location import 변환 경로에서 `currentVersion.representations()`를 Nessie snapshot에 보존해 Iceberg REST `GET view`의 `versions[].representations` 누락을 수정. 로컬 검증: `:nessie-catalog-format-iceberg:test --tests org.projectnessie.catalog.formats.iceberg.nessie.TestNessieModelIceberg.icebergViewSnapshotToNessiePreservesRepresentations`, `:nessie-catalog-format-iceberg:test --tests org.projectnessie.catalog.formats.iceberg.nessie.TestNessieModelIceberg`, `:nessie-catalog-format-iceberg:spotlessCheck`. **5번째 Nessie 머지, 6번째 Lakehouse upstream 머지 기여** |
| Nessie | [#12432](https://github.com/projectnessie/nessie/pull/12432) Normalize S3 scheme in IcebergConfigurer writeable derivation (issue #12426) | 2026-06-19 | dimas-b 6/16 @snazy 의견 요청 → snazy 6/19 LGTM APPROVED 직후 머지. `s3a://`/`s3n://` table metadata location을 `s3://` warehouse prefix와 비교할 때 normalize해서 S3 signer `writeable[]` 누락을 수정. 로컬 검증: `:nessie-catalog-service-rest:spotlessCheck`, `:nessie-catalog-service-rest:test --tests org.projectnessie.catalog.service.rest.TestIcebergConfigurer`. **4번째 Nessie 머지, 5번째 Lakehouse upstream 머지 기여** |
| Polaris | [#4451](https://github.com/apache/polaris/pull/4451) docs: add production configuration pages for AWS S3 and Azure Blob storage (issue #1325) | 2026-05-27 | dimas-b + flyrain 2-round 리뷰 반영 후 머지. AWS S3 + Azure Blob 두 production config 페이지 신규 추가. flyrain의 "3개 IAM identity 다뤄달라" 요청 반영해 IAM identities overview + Polaris service identity 섹션 추가. **첫 Polaris 머지, 첫 Apache org 머지 기여** |
| Nessie | [#12431](https://github.com/projectnessie/nessie/pull/12431) CLI `--stdout`/`-S` for stream-backed terminal (issue #10865) | 2026-05-26 | dimas-b APPROVED + merge. `system(false).streams(...).type("dumb")` 로 redirected stdout/pipe 시 PTY 우회. 5/25 1차 APPROVED with 2 nits → 5/26 description 다듬어 `e38ddd30` push → dimas-b 재APPROVED → 17분 뒤 머지. 3번째 머지 기여 |
| Nessie | [#12425](https://github.com/projectnessie/nessie/pull/12425) CLI `--plain`/`-P` alias (issue #10865) | 2026-05-20 | dimas-b APPROVED + merge. **후속 작업 필요**: `--stdout`/`-S` + `PosixSysTerminal` 강제 — 이슈 #10865는 OPEN 유지 |
| Nessie | [#12424](https://github.com/projectnessie/nessie/pull/12424) Cloud Object Storage 일관성 문서 (issue #5349) | 2026-05-20 | dimas-b + @snazy APPROVED. **첫 머지 기여** |

## 정찰 완료 — 진입 가능 후보

> 재검증: 2026-07-13

활성 후보표는 **open, assignee 없음, linked/open PR 없음, 명확한 작업 의도 댓글 없음**을 모두 다시 확인한 항목만 유지한다. 최근 maintainer가 구현 방향을 확인한 작은 변경을 우선하고, stale·설계 논쟁·release workflow 변경은 코드 PR이 아니라 확인 댓글 단계로 낮춘다.

| 우선 | 생성일 | 프로젝트 | 이슈 | 성격 | 다음 액션 / 리스크 |
|---|---|---|---|---|---|
| 🟢 1 | 2026-07-08 | Apache Iceberg | [#17139](https://github.com/apache/iceberg/issues/17139) table spec 표의 셀 줄바꿈 개선 | 문서/UI | assignee·댓글·linked PR 없음. CSS/Markdown 렌더링 위치와 docs 검증 명령을 확인해 작은 문서 PR로 진입 |
| 🟢 2 | 2026-02-24 | Project Nessie | [#12130](https://github.com/projectnessie/nessie/issues/12130) `/history/merge`의 `dryRun` JSON 필드 매핑 | API/회귀 | assignee·댓글·linked PR 없음. current `main`과 OpenAPI 생성 모델에서 먼저 재현하고, 재현되면 직렬화 테스트와 최소 수정으로 제한 |
| 🟡 3 | 2026-07-09 | Apache Iceberg | [#17140](https://github.com/apache/iceberg/issues/17140) Flink committer의 불필요한 catalog load fan-out | Flink/성능 | assignee·linked PR 없음. maintainer가 subtask 0 외에는 load를 생략하고 메시지 수신 시 실패시키는 방향에 동의. Flink 1.20/2.0 테스트 범위와 빌드 비용 확인 후 진입 |
| 🟡 4 | 2026-06-03 | Project Nessie | [#12503](https://github.com/projectnessie/nessie/issues/12503) Helm chart OCI artifact 퍼블리시 | Helm/Release | assignee·댓글·linked PR 없음. release workflow와 배포 레지스트리 선택이 필요하므로 구현 전 방향 확인 댓글 게시 |
| 🟠 5 | 2026-06-02 | Apache Polaris | [#4600](https://github.com/apache/polaris/issues/4600) JDBC `hasOverlappingSiblings` 추가 회귀 테스트 | 테스트/회귀 | linked PR·assignee는 없지만 stale. NoSQL 시나리오 이식 가치가 아직 있는지 maintainer에게 확인하고 stale 해제 전에는 구현하지 않음 |
| 🟠 6 | 2026-06-08 | Apache Polaris | [#4658](https://github.com/apache/polaris/issues/4658) table notification concurrent modification retry | 버그픽스 | linked PR·assignee는 없지만 stale이며 retry 경계가 미합의. UPDATE-only 범위와 기존 retry utility를 확인한 뒤 유지 여부 결정 |

### 이번 재검증에서 제외

- Polaris [#4802](https://github.com/apache/polaris/issues/4802): 구현 PR [#4921](https://github.com/apache/polaris/pull/4921)이 머지되어 종료 대기 상태.
- Kubernetes SIGs / descheduler [#1887](https://github.com/kubernetes-sigs/descheduler/issues/1887), Kueue [#12481](https://github.com/kubernetes-sigs/kueue/issues/12481): 이미 completed로 닫힘.
- Kubernetes SIGs / cluster-api-provider-aws [#6062](https://github.com/kubernetes-sigs/cluster-api-provider-aws/issues/6062): triage accepted 이후 기존 참여자가 작은 PR 제출 의사를 명시.
- PyIceberg [#3543](https://github.com/apache/iceberg-python/issues/3543): maintainer가 truthiness 설계 자체에 우려를 제기해 구현 후보에서 제외.
- Polaris [#4874](https://github.com/apache/polaris/issues/4874): maintainer가 NoSQL의 별도 cache backend를 지적해 기존 문제 정의로는 진입하지 않음.

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
