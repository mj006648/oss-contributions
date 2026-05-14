# Kyverno

[Kyverno](https://github.com/kyverno/kyverno)는 Kubernetes 정책 엔진. TwinX 클러스터의 admission policy controller로 사용되며, RESTARTS 누적 디버깅 중 chart의 cert-manager 통합이 incomplete하다는 사실을 발견.

## 본인 연구·운영 중 직접 발견한 이슈

### chart v3.7.1 ~ v3.7.2 cert-manager 통합 incomplete (신규 등록 예정)

`admissionController.certManager.enabled=true` 활성화 시 Certificate 리소스는 생성되나 컨테이너 내부 `certmanager-controller` 모듈이 비활성화되지 않아 cert-manager ↔ 내부 모듈 사이에 무한 핑퐁(14분간 220+회 관찰). chart v3.7.2(현재 최신)에서도 재현됨. values에 `disableCertManager` 같은 끄는 옵션 부재.

자세한 분석: [issue-new-certmanager-incomplete/](./issue-new-certmanager-incomplete/)

## 참고 링크

- [Kyverno GitHub](https://github.com/kyverno/kyverno)
- [Helm chart repo](https://kyverno.github.io/kyverno/)
- [Contributing Guide](https://github.com/kyverno/kyverno/blob/main/CONTRIBUTING.md)
- DCO 방식 (`git commit -s`)

## 개발 환경 메모

- 언어: Go
- chart 언어: Helm/YAML
- 본인 운영 환경: TwinX commit 4e1fa57(자체 cert 모드)로 롤백 상태. 위임 시도 commit e8b739f는 실패.
