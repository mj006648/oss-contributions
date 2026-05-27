# OSS Contributions Tracker

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
| Nessie | [#12426](https://github.com/projectnessie/nessie/issues/12426) `IcebergConfigurer.writeable` s3a:// vs s3:// | 의도 코멘트 게시, maintainer 답 대기 | 2026-05-27 | 멘션 없이 게시 ([comment](https://github.com/projectnessie/nessie/issues/12426#issuecomment-4551881490)). 답 받으면 fork → DCO sign-off → PR |
| iceberg-python | [#3247](https://github.com/apache/iceberg-python/issues/3247) LoadTable per-table config 머지 누락 | 의도 코멘트 게시, maintainer 답 대기 | 2026-05-27 | 첫 iceberg-python 진입, 멘션 없이 게시 ([comment](https://github.com/apache/iceberg-python/issues/3247#issuecomment-4551881977)). 답 받으면 ICLA 확인 → fork → PR |

## 정찰 완료 — 진입 가능 후보

다음 PR로 검토 중인 fresh 이슈들. 2026-05-27 엄격한 룰로 재정찰:
- 60일 이내 fresh, 코멘트 0건, linked PR 0건, assignee 0명 모두 만족하는 것만 유지.

| 우선 | 프로젝트 | 이슈 | 작업 종류 | 무엇 | 왜 필요 | 본인 강점 | 위험 | 상태 |
|---|---|---|---|---|---|---|---|---|
| 🟢 1 | Nessie | [#12429](https://github.com/projectnessie/nessie/issues/12429) [Feature]: add nessie GC to the helm chart | 인프라 (Helm) | 현재 Nessie Helm chart에 Nessie GC 컴포넌트가 빠져있음. Helm chart values + templates 추가 | Helm으로 Nessie 배포한 사용자가 GC 별도로 설정해야 하는 불편 | TwinX 운영 + ArgoCD/Helm 경험 직결 ([[project_trident_components]] Trident ArgoCD 작업 다수) | feature 추가라 maintainer가 디자인 의견 강하게 가질 수 있음, dev ML 토론 필요 가능성 | 6일 fresh / 코멘트 0건 / linked PR 0건 / assignee 0명 |
| 🟢 2 | Iceberg | [#16530](https://github.com/apache/iceberg/issues/16530) Flaky tests in iceberg-azure integrationTest | 테스트 안정화 | `iceberg-azure:integrationTest`의 `TestADLSFileIO` / `TestADLSInputStream`이 testcontainer 환경에서 간헐 실패. CI 로그상 `ContainerFetchException`. testcontainer 셋업 + Azure mock 컨테이너 안정화 | flaky test는 CI 신뢰도/머지 속도 저하 | Trident에서 Docker/testcontainer/K8s 운영 경험 | flaky 디버깅은 재현성이 까다로워 PR 임팩트 입증이 핵심. 첫 Iceberg PR로는 부담 — Polaris #4451 후속이라는 의미로 #3247이 우선 | 4일 fresh / 코멘트 0건 / linked PR 0건 |

## Merged

| 프로젝트 | PR | 머지일 | 비고 |
|---------|----|--------|------|
| Polaris | [#4451](https://github.com/apache/polaris/pull/4451) docs: add production configuration pages for AWS S3 and Azure Blob storage (issue #1325) | 2026-05-27 | dimas-b + flyrain 2-round 리뷰 반영 후 머지. AWS S3 + Azure Blob 두 production config 페이지 신규 추가. flyrain의 "3개 IAM identity 다뤄달라" 요청 반영해 IAM identities overview + Polaris service identity 섹션 추가. **첫 Polaris 머지, 4번째 Apache 머지 기여** |
| Nessie | [#12431](https://github.com/projectnessie/nessie/pull/12431) CLI `--stdout`/`-S` for stream-backed terminal (issue #10865) | 2026-05-26 | dimas-b APPROVED + merge. `system(false).streams(...).type("dumb")` 로 redirected stdout/pipe 시 PTY 우회. 5/25 1차 APPROVED with 2 nits → 5/26 description 다듬어 `e38ddd30` push → dimas-b 재APPROVED → 17분 뒤 머지. 3번째 머지 기여 |
| Nessie | [#12425](https://github.com/projectnessie/nessie/pull/12425) CLI `--plain`/`-P` alias (issue #10865) | 2026-05-20 | dimas-b APPROVED + merge. **후속 작업 필요**: `--stdout`/`-S` + `PosixSysTerminal` 강제 — 이슈 #10865는 OPEN 유지 |
| Nessie | [#12424](https://github.com/projectnessie/nessie/pull/12424) Cloud Object Storage 일관성 문서 (issue #5349) | 2026-05-20 | dimas-b + @snazy APPROVED. **첫 머지 기여** |

## 종결 / Closed Upstream

| 프로젝트 | 이슈/PR | 결과 |
|---------|---------|------|
| Kubeflow | [spark-operator#2924](https://github.com/kubeflow/spark-operator/issues/2924) EmptyDir medium not forwarded | **CLOSED** (2026-05-18). 본인 의도 코멘트만 남기고 종결됨, 후속 추적 종료 |
| Milvus | [pymilvus#2724](https://github.com/milvus-io/pymilvus/issues/2724) pkg_resources deprecated | **CLOSED** (다른 사용자에 의해). 본인 데이터 포인트(setuptools 82.x hard failure) 코멘트로 milvus-io organization 진입 흔적 남김 |

## 정찰 완료, 회피한 후보


| 프로젝트 | 이슈 | 회피 이유 |
|---------|------|----------|
| Nessie | [#11759](https://github.com/projectnessie/nessie/issues/11759) S3 access key/secret 못 받음 | 160일 묵힘 + dimas-b가 사용자에게 `pathPrefix` 트레일링 슬래시 가이드 (2025-12-17). 사용자 답변 대기 상태, PR 진입 어색 (2026-05-27) |
| Nessie | [#12367](https://github.com/projectnessie/nessie/issues/12367) Spark 4.0 Maven artifact | dimas-b 5/12 코멘트로 "Spark 4 support는 #12126로 이미 v0.107.4에 배포됨"이라고 답변. **사실상 해결된 이슈** (2026-05-27) |
| Iceberg | [#15916](https://github.com/apache/iceberg/issues/15916) Spark branch precedence docs | @yadavay-amzn이 PR [#15917](https://github.com/apache/iceberg/pull/15917)로 진행 중, 5/12 committer 리뷰 반영 push, 머지 직전 (2026-05-27) |
| iceberg-python | [#1008](https://github.com/apache/iceberg-python/issues/1008) Write Support 문서 | @pramila-bishnoi이 PR 제출 의도 코멘트 (2025-11) + kevinjqliu(committer)가 OK 답변. 이미 작업자 있음 (2026-05-27) |
| Polaris | [#2774](https://github.com/apache/polaris/issues/2774) Move blogs to separate branch | @tiru-venkatesh가 dev mailing list 제안서 제출 후 진행 중 (2026-01-31). 가로채기 회피 (2026-05-27) |
| Polaris | [#996](https://github.com/apache/polaris/issues/996) Using case insensitive storage type names | @evindj + @tiru-venkatesh 둘 다 관심 + dev ML 토론 진행 (2026-01). 가로채기 회피 (2026-05-27) |
| ArgoCD  | [#18198](https://github.com/argoproj/argo-cd/issues/18198) `--request-timeout` docs/code 불일치 | 5/14 의도 코멘트 후 12일+ 무반응. lakehouse 3종 집중 전략에 따라 PR effort 미투입 (2026-05-27) |
| Kyverno | [#16103](https://github.com/kyverno/kyverno/issues/16103) chart cert-manager 통합 incomplete | 5/14 등록 후 12일+ 무반응. lakehouse 3종 집중 전략에 따라 PR effort 미투입 (2026-05-27) |
| PyIceberg | [#1008](https://github.com/apache/iceberg-python/issues/1008) Write Support docs | 다른 작업자 진행 중 |
| PyIceberg | [#1169](https://github.com/apache/iceberg-python/issues/1169) Time64[ns] | assigned + stale PR 다수 |
| PyIceberg | [#1310](https://github.com/apache/iceberg-python/issues/1310) `@override` 추가 | 다수 stale 시도 |
| Iceberg | [#15916](https://github.com/apache/iceberg/issues/15916) Spark branch docs | PR #15917 진행 중 |
| Iceberg | [#14227](https://github.com/apache/iceberg/issues/14227) REST fixture logs | PR #14260 리뷰 대기 |
| Iceberg | [#14925](https://github.com/apache/iceberg/issues/14925) spec partition value | spec 변경이라 첫 기여로 부담 (후보로 보류) |
| ArgoCD | [#14705](https://github.com/argoproj/argo-cd/issues/14705) timeout 메시지 | 다수 stale 시도 |
| Polaris | [#1119](https://github.com/apache/polaris/issues/1119) curl cookbook | @jbonofre assigned |
| Polaris | [#1323](https://github.com/apache/polaris/issues/1323) Helm README | @MonkeyCanCode 진행 중 |
| Supabase | [auth#880](https://github.com/supabase/auth/issues/880) getUserByEmail | maintainer 거절(다른 방향), 7명 줄 섬 |
| CNPG | [#4042](https://github.com/cloudnative-pg/cloudnative-pg/issues/4042) postInitSQL plpgsql | closed in favor of #3783 (해결됨) |
| Rook | [#5670](https://github.com/rook/rook/issues/5670) volume resizing docs | 5년 묵힘, docs sample PR로 우회 가능 |
| kubernetes-sigs/kueue | [#5172](https://github.com/kubernetes-sigs/kueue/issues/5172) two-step admission docs | @JasminPradhan 작업 중 |
| kubernetes-sigs/gateway-api | [#4464](https://github.com/kubernetes-sigs/gateway-api/issues/4464) gateway name too big | @nicknikolakakis 의도 댓글, lifecycle/active |
| kubernetes-sigs/gateway-api | [#4347](https://github.com/kubernetes-sigs/gateway-api/issues/4347) API spec links | @YASHMAHAKAL assigned, PR #4348 |
| kubernetes-sigs/kustomize | [#4338](https://github.com/kubernetes-sigs/kustomize/issues/4338) consolidate docs | 다중 assigned, 5년 진행 중 |
| kubernetes-sigs/descheduler | [#1478](https://github.com/kubernetes-sigs/descheduler/issues/1478) e2e migrate | 다른 작업자 + maintainer 가치 의문 |
| vercel/next.js | [#42846](https://github.com/vercel/next.js/issues/42846) AppType bug | 4개 open PR 경쟁 |
| vercel/next.js | [#41281](https://github.com/vercel/next.js/issues/41281) getStaticPaths errors | 3년째 묵힘, 다수 PR 방치 |
| python/devguide | [#1286](https://github.com/python/devguide/issues/1286) bytecode docs | PR stuck, maintainer 방향 미정 |
| NVIDIA/gpu-operator | #1677 | Dependabot 자동 PR (사람 이슈 X) |

## Closed / Rejected

(거절도 자산. 받은 피드백을 `learnings/`에 정리)

## Watching

- Apache Iceberg PyIceberg roadmap
- ArgoCD v3 milestone
- Nessie Catalog API 발전 동향

## Roadmap — 진입하고 싶은 organization

본인 GitHub 프로필 `Activity overview`에 추가하고 싶은 organization 배지 목록과 진입 후보. 우선순위 순.

| 순위 | Organization | 상태 | 진입 후보 / 메모 |
|------|------------|------|----------------|
| 1 | `@apache` | 진행 중 | Polaris #1325 maintainer 응답, Iceberg/Spark/Trino docs 다수 |
| 2 | `@kubeflow` | 진행 중 | spark-operator #2924 EmptyDir medium bug, #2891 ports |
| 3 | `@milvus-io` | 코멘트 추가 | pymilvus #2724 본인 production 데이터 포인트 |
| 4 | `@kubernetes-sigs` | 정찰 완료, 진입 어려움 | kueue/gateway-api/kustomize/descheduler 모두 작업자 있음. 본인 발견 버그로 진입 가능 |
| 4 | `@NVIDIA` | 정찰 완료, 어려움 | good first issue 라벨 정책 없음. 본인 l40s/MIG 운영 발견 버그로 진입 가능 |
| 5 | `@supabase` | 정찰 완료 | docs 영역 일부 가능 (#42997 작업자 있음). 본인 PostgreSQL+Keycloak 직결 |
| 6 | `@vercel` | 정찰 완료, 어려움 | good first issue 거의 미사용. Next.js examples/ 추가 PR로 진입 가능 |
| 7 | `@python` | 정찰 완료 | devguide docs 다수, 작업자 적은 영역 (#1791 Homebrew, #1786 GH Actions 등) |
| 8 | `@fastapi` | 정찰 완료, 어려움 | good first issue 0건. sub-project 본인 발견 docs gap으로 진입 |

진입 패턴 (Nessie 첫 PR에서 검증된 워크플로우):
1. 각 프로젝트 `good first issue` 또는 `help wanted` 라벨 정찰
2. 다른 작업자 없는 후보 선정
3. 이슈에 의도 코멘트 게시 (충돌 방지)
4. fork & clone, 작업 브랜치
5. DCO sign-off 커밋 → fork push → PR 생성
6. CLA 봇 안내 따라 서명
7. `scripts/check-responses.sh add`로 추적 목록에 추가

---

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

- [Trident-Portal](https://github.com/mj006648/Trident-Portal) — 석사 연구 포털 (Next.js + FastAPI)
- [Trident-Twin](https://github.com/mj006648/Trident-Twin) — 3D Omniverse Twin
- master-thesis — 논문 원고 (local)
