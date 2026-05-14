# ArgoCD #18198 — `--request-timeout` exists in docs but not in code

- 원본 이슈: https://github.com/argoproj/argo-cd/issues/18198
- 등록자: 익명 (Andrii Korotkov 추정 — 첫 댓글에서 언급됨)
- 등록일: 2024-05-13
- 라벨: bug, good first issue, component:server, component:docs, version:2.14
- assignee: 없음
- PR: 없음 (2년 묵힘)
- 상태: 분석 단계

## 이슈 본문 요약

ArgoCD server의 `--request-timeout` 옵션이 문서에는 존재하지만 실제 코드에서 파싱되지 않는다. 검색해보면 코드에 진입점이 없고 문서에만 언급됨.

### 추가 단서 (maintainer @daengdaengLee 코멘트, 2025-05-11)

- 문서 위치: https://argo-cd.readthedocs.io/en/stable/operator-manual/server-commands/argocd-server/
- 코드 위치: `cmd/argocd-server/commands/argocd_server.go`
- `docs/` 폴더 안에 `--request-timeout` 언급 다수, 그러나 `cmd/` 안에는 구현 없음

## 수정 방향 (두 가지 선택지)

### 옵션 A: 문서에서 제거 (안전, 작은 변경)

- 사실관계: 옵션이 코드엔 없으므로 문서가 잘못된 것
- 모든 `--request-timeout` 언급을 `docs/` 폴더에서 제거 또는 정확한 옵션 이름으로 교체
- 장점: 문서 변경만이라 빠른 머지 가능
- 단점: 사용자가 진짜로 timeout 제어 기능을 원할 수 있음. 그 경우 기능 누락 해결 안 됨.

### 옵션 B: 코드에 옵션 추가 (큰 변경, 진짜 fix)

- `cmd/argocd-server/commands/argocd_server.go`에 `--request-timeout` flag 추가
- gRPC server에 timeout interceptor 연결
- 장점: 실제 기능 추가, 임팩트 큼
- 단점: gRPC interceptor 작성 + 테스트 필요, 첫 ArgoCD 기여로는 부담

### 권장: 먼저 maintainer에 의도 물어보고 결정

코멘트에서 "어느 방향이 좋을까요?"를 명시적으로 묻고, 응답에 따라 진행. 보고자가 "둘 중 하나"로 표현했으므로 둘 다 옳다.

## 작업 체크리스트

- [x] 이슈 본문 정독
- [x] maintainer 댓글로 코드/문서 위치 확인
- [x] 의도 코멘트 게시 (https://github.com/argoproj/argo-cd/issues/18198#issuecomment-4447111534)
- [ ] ArgoCD repo fork & clone
- [ ] Go toolchain (1.22+) 환경 확인
- [ ] `cmd/argocd-server/commands/argocd_server.go` 정독
- [ ] `docs/` 내 `--request-timeout` grep
- [ ] 응답 받으면 작업 진행
- [ ] DCO sign-off 커밋
- [ ] PR 제출

## 본인 연구 연관성

ArgoCD는 TwinX `argocd/trident`에서 매일 사용. 본 연구의 운영 평면이라 친숙도 높음. 다만 본 이슈는 Trident 운영과 직접 관련 없는 일반 server flag 이슈.
