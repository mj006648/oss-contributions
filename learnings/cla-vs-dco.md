# CLA vs DCO

## CLA (Contributor License Agreement)

- 별도 서명 문서 (PDF 또는 웹 폼)
- 1회 서명 후 해당 프로젝트 평생 유효
- 회사 소속이면 회사 명의로 따로 서명해야 하는 경우 있음
- 예: Apache (ICLA), Google CLA, CNCF EasyCLA

## DCO (Developer Certificate of Origin)

- 별도 서류 없음
- 커밋 메시지에 `Signed-off-by: Name <email>` 한 줄로 충족
- `git commit -s` 명령으로 자동 추가
- 예: Linux Kernel, Nessie, ArgoCD, Kubernetes(현재 EasyCLA로 전환)

## 본 트래커에서 관리하는 프로젝트별 방식

| 프로젝트 | 방식 | 비고 |
|---------|------|------|
| Nessie  | DCO  | `git commit -s` 만 하면 됨 |
| Apache Iceberg | ICLA | Apache Individual CLA 서명 1회 필요 |
| ArgoCD  | DCO  | CNCF EasyCLA 봇이 안내 |
| Kubernetes | CLA | CNCF EasyCLA |

## 첫 PR 전 체크

1. 해당 repo의 `CONTRIBUTING.md` 또는 `DCO.md` 확인
2. GitHub 이메일과 커밋 이메일 일치 확인
3. `git commit -s` 습관화
4. 봇이 "CLA not signed" 알리면 안내 링크 따라가서 1분 안에 해결
