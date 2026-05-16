# OSS Contributions Tracker

클라우드 네이티브 데이터 인프라 프로젝트(Nessie, Apache Iceberg, ArgoCD, Kubernetes 등)에 대한 오픈소스 기여 활동을 기록하는 개인 저장소.

석사 연구(GIST AI, Apache Iceberg 기반 Cloud-Native Trident Lakehouse) 수행 중 발견한 upstream 개선점을 정리하고, 이슈 등록부터 PR 머지까지의 전 과정을 추적한다.

---

## In Progress

| 프로젝트 | 이슈/PR | 상태 | 시작일 | 비고 |
|---------|---------|------|--------|------|
| Nessie  | [#10865](https://github.com/projectnessie/nessie/issues/10865) CLI STDOUT redirect 버그 | **PR [#12425](https://github.com/projectnessie/nessie/pull/12425) discussion round 1** (2026-05-16) | 2026-05-14 | `--plain`/`-P` alias 추가. dimas-b: "변경은 OK지만 원래 의도는 `PosixSysTerminal` 강제였음". 본인 B 선택: 이 PR 머지 후 후속 PR (`--stdout`/`-S` + PosixSysTerminal). dimas-b 머지 대기 |
| Nessie  | [#5349](https://github.com/projectnessie/nessie/issues/5349) Cloud Object Storage 일관성 문서 | **PR [#12424](https://github.com/projectnessie/nessie/pull/12424) APPROVED** (2026-05-15) | 2026-05-14 | dimas-b APPROVED, @snazy 추가 리뷰 대기 |
| ArgoCD  | [#18198](https://github.com/argoproj/argo-cd/issues/18198) `--request-timeout` docs/code 불일치 | 의도 코멘트 게시, maintainer 응답 대기 | 2026-05-14 | A(docs-only) vs B(implement) 방향 결정 요청 |
| Polaris | [#1325](https://github.com/apache/polaris/issues/1325) Storage backend production config 문서 | **PR [#4451](https://github.com/apache/polaris/pull/4451) 제출** (2026-05-15) | 2026-05-14 | AWS S3 + Azure Blob 페이지 신규. MinIO+Spark/Trino/PyIceberg, Ceph(STS-unsupported), ADLS Gen2 happy/sad path 모두 end-to-end 검증. CLA bot/CI/리뷰 대기 |
| Kyverno | [#16103](https://github.com/kyverno/kyverno/issues/16103) chart cert-manager 통합 incomplete | 신규 이슈 등록, 응답 대기 | 2026-05-14 | 본인이 TwinX 운영 중 직접 발견. chart v3.7.2 검증 |
| Kubeflow | [spark-operator#2924](https://github.com/kubeflow/spark-operator/issues/2924) EmptyDir medium not forwarded | 의도 코멘트 게시, 작업자 없음 | 2026-05-14 | 재현 + bug fix PR 작업 진행 가능 |
| Milvus | [pymilvus#2724](https://github.com/milvus-io/pymilvus/issues/2724) pkg_resources deprecated | 이슈 closed (다른 사용자), 본인 데이터 포인트 기록 완료 | 2026-05-14 | setuptools 82.x hard failure 증언, milvus-io organization 진입 |

## 정찰 완료, 회피한 후보

| 프로젝트 | 이슈 | 회피 이유 |
|---------|------|----------|
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

## Merged

(아직 없음 — 곧 추가될 예정)

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

---

## 관련 저장소

- [Trident-Portal](https://github.com/mj006648/Trident-Portal) — 석사 연구 포털 (Next.js + FastAPI)
- [TwinX](https://github.com/mj006648/Twinx) — ArgoCD GitOps
- [Trident-Twin](https://github.com/mj006648/Trident-Twin) — 3D Omniverse Twin
- master-thesis — 논문 원고 (local)

---

Last updated: 2026-05-15 (polaris PR #4451 제출)
