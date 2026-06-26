# kubernetes-sigs

Kubernetes 공식 sub-project organization. cluster-api, kustomize, descheduler, gateway-api, kueue, external-dns 등 100+ repository. 본인 연구는 TwinX(ArgoCD GitOps) + Spark on K8s + cert-manager 등 직접 활용 영역.


## 현재 진행 중 (2026-06-26)

| repo | 이슈/PR | 상태 | 다음 액션 |
|---|---|---|---|
| lws | [#895](https://github.com/kubernetes-sigs/lws/issues/895) / [#896](https://github.com/kubernetes-sigs/lws/pull/896) LWS metadata propagation | PR 오픈, CLA/ok-to-test 완료, Prow CI 통과, use case 답변 완료 | 중복 PR [#897](https://github.com/kubernetes-sigs/lws/pull/897)도 열린 상태라 maintainer의 방향 판단 대기 |
| agent-sandbox | [#1029](https://github.com/kubernetes-sigs/agent-sandbox/issues/1029) / [#1033](https://github.com/kubernetes-sigs/agent-sandbox/pull/1033) Python SDK `use_pod_ip` handling | PR 오픈, CLA 완료, `needs-ok-to-test`, approver가 field 제거 방향 제안 | SHRUTI6991 답변 대기. 확인되면 `use_pod_ip` 제거 방향으로 docs/tests/code 정리 |

## 정찰 결과 (2026-05-14)

### kueue (Spark/AI 워크로드 큐잉)
| 이슈 | 평가 |
|------|------|
| #5172 two-step admission docs | **회피** — @JasminPradhan assigned + 작업 중 (2026-06부터) |
| #3880 kueue-viz backend params | 후속 정찰 (assignee 없음) |
| #3439 WorkloadPriorityClass not found event | 후속 정찰 |

### gateway-api (Ingress 차세대)
| 이슈 | 평가 |
|------|------|
| #4464 gateway name too big | **회피** — @nicknikolakakis가 2026-05-10 의도 댓글 + maintainer에 4개 질문, lifecycle/active |
| #4347 API spec links in guides | **회피** — @YASHMAHAKAL assigned + PR #4348 제출됨 |

### kustomize (Helm 대안, 본인 매일 사용)
| 이슈 | 평가 |
|------|------|
| #4338 consolidate docs | **회피** — @ashnehete + @m-alikhizar 둘 assigned, 2021년부터 다중 contributor 체계 |
| #5452, #4292, #4080 | 후속 정찰 가능 (lifecycle/frozen 또는 신선도 낮음) |

### descheduler
| 이슈 | 평가 |
|------|------|
| #1478 e2e migrate to image | **회피** — 6개 task 중 4개 완료, 2개는 maintainer가 "가치 의문" |

### external-dns
| 이슈 | 평가 |
|------|------|
| #5150 improve coverage | **회피** — lifecycle/frozen |
| #3565 multiple namespaces | 후속 정찰 가능 |

## 핵심 발견

**kubernetes-sigs는 메가 organization 양상**: `good first issue` 라벨이 붙으면 며칠 안에 누군가 가져감. 자연 진입 어려움.

## 진입 전략

현재는 LWS/agent-sandbox처럼 작은 Python/Kubernetes controller 이슈로 진입 가능성이 확인됨. 기본 전략은 그대로 유지한다:

1. **본인이 운영 중 발견한 sub-project 관련 버그**를 직접 등록 (kyverno #16103 패턴)
2. **작고 명확한 Python/Kubernetes controller 이슈**에 의도 댓글 후 PR
3. **kueue/gateway-api/kustomize 중 본인 Trident 운영 중 마주친 실제 문제**로 새 이슈 작성

진입 후보 (다음 세션):
- kueue 본인 SparkApplication 큐잉 시 발견할 수 있는 이슈
- kustomize: Trident GitOps에서 사용 중 발견한 문제

## 참고

- DCO 방식 (`git commit -s`)
- k8s-ci-robot 자동화 (`/good-first-issue`, `/assign`, `/lifecycle` 명령어)
- Slack: `kubernetes.slack.com` SIG별 채널
