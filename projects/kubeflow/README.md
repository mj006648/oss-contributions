# Kubeflow Spark Operator

[kubeflow/spark-operator](https://github.com/kubeflow/spark-operator)는 Kubernetes에서 Apache Spark를 운영하는 공식 operator. Trident가 매일 사용하는 핵심 컴포넌트(Stats Service가 SparkApplication CR을 생성, ArgoCD가 spark-on-k8s-operator chart 배포).

## 진행 중

- [#2924 EmptyDir medium field not forwarded](./issue-2924-emptydir-medium/) — bug fix PR 진행 예정

## 다음 세션 후보 (정찰 완료)

| 이슈 | 평가 | 진입 가능성 |
|------|------|---------|
| [#2924](https://github.com/kubeflow/spark-operator/issues/2924) EmptyDir medium not forwarded | 작업자 없음, 코드 위치 명시 | 진행 중 |
| [#2891](https://github.com/kubeflow/spark-operator/issues/2891) Ports defined in executor/driver config not exposed | 작업자 없음, bug, Service 생성 코드 수정 | 후보 |
| [#2924 외 다른 bug] | - | - |

## 회피 후보

| 이슈 | 회피 이유 |
|------|---------|
| [#2935](https://github.com/kubeflow/spark-operator/issues/2935) k8s 1.35 support | vjanelle 답변 + 보고자 해결 — 종결 가까움 |

## 참고

- 공식 사이트: https://www.kubeflow.org/docs/components/spark-operator/
- Slack: kubeflow.slack.com #kubeflow-spark-on-kubernetes
- 언어: Go
- DCO sign-off 필요
- 로컬 clone 예정: `~/chang/Git/spark-operator`

## 본인 운영 자산

본인 Trident `argocd/trident-spark/` (TwinX)에서 spark-operator 매일 운영. SparkApplication CR을 stats-service `routers/spark.py`가 생성. 본인이 실제 사용자라 bug 재현·검증 빠름.
