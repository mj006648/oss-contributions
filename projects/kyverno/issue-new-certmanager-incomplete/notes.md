# Kyverno chart cert-manager 통합 incomplete (신규 이슈 등록 예정)

- 등록 예정 repo: https://github.com/kyverno/kyverno
- 발견자: 본인 (TwinX 클러스터 운영 중)
- 발견 시점: 2026-05-01 전후 (TwinX commit e8b739f → 4e1fa57)
- 검증 시점: 2026-05-14 (chart v3.7.2 현재 최신에서도 재현 확인)
- 라벨 후보: bug, helm-chart

## 본인이 발견한 사실

### 증상

`admissionController.certManager.enabled=true`로 cert-manager 위임 모드를 켜면:

1. cert-manager가 `kyverno-svc.<ns>.svc.kyverno-tls-pair` Secret에 인증서 발급
2. kyverno 컨테이너 내부 `certmanager-controller` 모듈이 같은 Secret에 자기 키로 덮어씀
3. cert-manager가 "Secret contains a private key that does not match the current CertificateRequest" 판단 후 재발급
4. 무한 반복 — TwinX 클러스터에서 14분간 220+회 직접 관찰

### 검증 (chart v3.7.1 / v3.7.2 모두 재현됨)

```bash
helm template kyverno kyverno/kyverno --version 3.7.2 \
  --set admissionController.certManager.enabled=true \
  | grep -E "caSecretName|tlsSecretName"
```

출력 (4건):
```
- --caSecretName=kyverno-svc.default.svc.kyverno-tls-ca
- --tlsSecretName=kyverno-svc.default.svc.kyverno-tls-pair
- --caSecretName=kyverno-cleanup-controller.default.svc.kyverno-tls-ca
- --tlsSecretName=kyverno-cleanup-controller.default.svc.kyverno-tls-pair
```

이 args는 컨테이너 내부 `certmanager-controller` 모듈이 해당 Secret을 관리한다는 의미. 즉 cert-manager에 위임했음에도 내부 모듈이 같은 Secret을 함께 관리하려 함.

### values.yaml 누락

`helm show values kyverno/kyverno --version 3.7.2`로 확인한 결과 다음 옵션 부재:
- `disableCertManager`
- `certRenewer.enabled`
- 내부 cert 모듈을 끄는 어떤 boolean

→ 사용자는 cert-manager로 위임하고 싶어도 내부 모듈을 끌 수 없음.

### 기존 이슈 검색 결과

`kyverno/kyverno` 저장소에서:
- `cert-manager` 검색: #9074, #15730 → 둘 다 무관 (pullsecret, ArgoCD sync)
- `caSecretName` 검색: #15244 → chore, 무관
- `certManager.enabled` 검색: 결과 없음

→ **본인이 처음 보고하는 버그**로 판단.

## 이슈 본문 (영어, 등록 직전 검토용)

```markdown
### Kyverno Version

chart 3.7.2 (latest), also reproduces on 3.7.1
App version: v1.17.2

### Kubernetes Version

1.31

### Kubernetes Platform

vanilla (kubeadm)

### Description

When enabling cert-manager delegation via
`admissionController.certManager.enabled=true`, the chart still wires
`--caSecretName` / `--tlsSecretName` args into the admission and cleanup
controller containers, so the in-process `certmanager-controller` module
remains active. This leads to a fight over the TLS Secrets between
cert-manager and the in-process module:

1. cert-manager issues a certificate into
   `kyverno-svc.<ns>.svc.kyverno-tls-pair`.
2. The in-process controller overwrites the Secret with its own
   self-managed key/cert.
3. cert-manager then detects "Secret contains a private key that does
   not match the current CertificateRequest" and reissues.
4. The cycle repeats — observed ~220 iterations in 14 minutes on our
   cluster.

`values.yaml` has no option to disable the in-process certmanager
controller (e.g. `disableCertManager`, `certRenewer.enabled`), so users
cannot resolve this from values alone.

### Steps to Reproduce

```bash
helm template kyverno kyverno/kyverno --version 3.7.2 \
  --set admissionController.certManager.enabled=true \
  | grep -E "caSecretName|tlsSecretName"
```

Expected when delegating to cert-manager: no `--caSecretName` /
`--tlsSecretName` args on the controller containers (or an explicit
flag that disables the in-process certmanager module).

Actual output (4 occurrences):

```
- --caSecretName=kyverno-svc.default.svc.kyverno-tls-ca
- --tlsSecretName=kyverno-svc.default.svc.kyverno-tls-pair
- --caSecretName=kyverno-cleanup-controller.default.svc.kyverno-tls-ca
- --tlsSecretName=kyverno-cleanup-controller.default.svc.kyverno-tls-pair
```

### Expected Behavior

When `admissionController.certManager.enabled=true` (and equivalently
for cleanupController), the chart should either:

1. Omit `--caSecretName` / `--tlsSecretName` args entirely so the
   in-process module no longer manages those Secrets, or
2. Add an explicit `--disable-cert-manager` (or similar) flag and pass
   it conditionally when cert-manager delegation is enabled.

### Workaround

Set `admissionController.certManager.enabled=false` and revert to the
self-managed cert mode. This is what we ended up doing on our cluster
(rolled back via TwinX commit 4e1fa57 after the failed delegation
attempt at e8b739f).

### Slack discussion / related

I couldn't find an existing issue for this. Closest searches:
- `cert-manager` → #9074, #15730 (unrelated)
- `caSecretName` → #15244 (chore, unrelated)
- `certManager.enabled` → no results

Happy to open a PR adding a `disableCertManager` toggle and gating the
relevant args on it, if maintainers agree on the direction.
```

## 작업 체크리스트

- [x] 본인 운영 환경에서 재현 (14분간 220+회 관찰)
- [x] chart v3.7.1 검증 (재현됨)
- [x] chart v3.7.2 (최신) 검증 (재현됨)
- [x] values.yaml에 disable 옵션 부재 확인
- [x] 기존 이슈 검색 (중복 없음)
- [x] 이슈 본문 영어 초안 작성
- [x] 이슈 등록 (#16103, 2026-05-14): https://github.com/kyverno/kyverno/issues/16103
- [ ] maintainer 응답 대기
- [ ] 응답에 따라 PR 진행

## 후속 PR 방향 (응답 받으면)

방향 A — chart values에 `disableCertManager` boolean 추가 (`helm/charts/kyverno/templates/...`)
방향 B — `certManager.enabled=true`일 때 자동으로 두 args 제거 + `--disable-cert-manager` 같은 새 flag 활성화

방향 A가 더 안전. B는 Go 코드 변경 동반될 수 있음.
