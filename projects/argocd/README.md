# Argo CD

[Argo CD](https://github.com/argoproj/argo-cd)는 CNCF Graduated 프로젝트로, Kubernetes를 위한 GitOps continuous delivery 도구다. Trident의 TwinX 저장소가 Argo CD를 통해 Lakehouse 구성요소(Milvus, Redis, Spark, Portal 등)를 sync wave 단위로 배포한다. 본 연구의 Cloud-Native 운영 평면 그 자체.

## 기여 후보 정찰 결과

| 이슈 | 제목 | 상태 | 평가 |
|------|------|------|------|
| [#18198](https://github.com/argoproj/argo-cd/issues/18198) | `--request-timeout` 문서엔 있고 코드엔 없음 | 2024-05 등록, assignee 없음, PR 없음, maintainer가 문제 위치 콕 집어줌 | 진행 후보 |
| [#14705](https://github.com/argoproj/argo-cd/issues/14705) | timeout 메시지 개선 | 3명 "할게요" 댓글, stale PR 1개 | 회피 (정치적 상황) |
| [#25684](https://github.com/argoproj/argo-cd/issues/25684) | events에 issuer 표시 | 미정찰 | 후속 정찰 |
| [#24065](https://github.com/argoproj/argo-cd/issues/24065) | `--header` multiple times 지원 | 미정찰 | 후속 정찰 |
| [#21052](https://github.com/argoproj/argo-cd/issues/21052) | CLI app list file 필터 | 미정찰 | 후속 정찰 |
| [#21059](https://github.com/argoproj/argo-cd/issues/21059) | CLI diff desired state | 미정찰 | 후속 정찰 |

## 진행 중

- [#18198 — `--request-timeout` docs/code 불일치](./issue-18198-request-timeout/)

## 참고 링크

- [Argo CD GitHub](https://github.com/argoproj/argo-cd)
- [Contributing Guide](https://argo-cd.readthedocs.io/en/stable/developer-guide/contributing/)
- CNCF EasyCLA — 첫 PR 시 봇이 자동 안내
- DCO 방식 — `git commit -s`
- Slack: `cloud-native.slack.com` #argo-cd

## 개발 환경 메모

- 언어: Go
- 빌드: make
- 로컬 clone 예정 경로: `~/chang/Git/argo-cd`
