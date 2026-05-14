# OSS Contributions Tracker

클라우드 네이티브 데이터 인프라 프로젝트(Nessie, Apache Iceberg, ArgoCD, Kubernetes 등)에 대한 오픈소스 기여 활동을 기록하는 개인 저장소.

석사 연구(GIST AI, Apache Iceberg 기반 Cloud-Native Trident Lakehouse) 수행 중 발견한 upstream 개선점을 정리하고, 이슈 등록부터 PR 머지까지의 전 과정을 추적한다.

---

## In Progress

| 프로젝트 | 이슈/PR | 상태 | 시작일 | 비고 |
|---------|---------|------|--------|------|
| Nessie  | [#10865](https://github.com/projectnessie/nessie/issues/10865) CLI STDOUT redirect 버그 | maintainer 응답 대기 | 2026-05-14 | 본 게임. fork & clone 완료, 빌드 환경 셋업 중 |
| Nessie  | [#5349](https://github.com/projectnessie/nessie/issues/5349) Cloud Object Storage 일관성 문서 | **PR [#12424](https://github.com/projectnessie/nessie/pull/12424) 제출** | 2026-05-14 | 첫 upstream PR. 리뷰 대기 |
| ArgoCD  | [#18198](https://github.com/argoproj/argo-cd/issues/18198) `--request-timeout` docs/code 불일치 | 의도 코멘트 게시 | 2026-05-14 | 2년 묵힘, assignee 없음, maintainer가 위치 콕 집어줌 |
| Polaris | [#1325](https://github.com/apache/polaris/issues/1325) Azure/GCS storage 문서 | 의도 코멘트 게시 | 2026-05-14 | PR #1435는 S3만, 나머지 storage 필요. 연구 직결 |
| Kyverno | [#16103](https://github.com/kyverno/kyverno/issues/16103) chart cert-manager 통합 incomplete | **신규 이슈 등록** | 2026-05-14 | 본인이 TwinX 운영 중 직접 발견. chart v3.7.2 검증 |

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
| 1 | `@apache` | **진행 중** | Polaris #1325, Iceberg #14925 등. 머지 시 자동 배지 |
| 2 | `@kubernetes-sigs` | 정찰 예정 | kueue (Spark/AI 워크로드 큐잉), gateway-api (Ingress 차세대), descheduler |
| 3 | `@vercel` | 정찰 예정 | next.js — Trident-Portal이 Next.js 기반, examples/ 또는 docs 진입 가능 |
| 4 | `@NVIDIA` | 정찰 예정 | k8s-device-plugin (GPU 할당, l40s 노드 직결), gpu-operator, dali (data loading) |
| 5 | `@fastapi` 또는 sub-org | 정찰 예정 | Stats Service 직결. 본체보다 sqlmodel / fastapi-users 등 sub-project 권장 |
| 6 | `@python` | 보류 | CPython 본체는 너무 큼. 대신 python/typing, python/peps, python/devguide 추천 |
| 7 | `@supabase` | 정찰 부분 완료 | BSL 라이선스, PostgreSQL+Next.js 스택 본인 친숙. 본체보다 sub-project 권장 |

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

Last updated: 2026-05-14
