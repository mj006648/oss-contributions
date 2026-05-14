# Apache Superset

Trident BI Dashboard = Superset. 본인이 Trino datasource auto-register, iframe embed via Next.js proxy.

## 정찰 결과 (2026-05-14)

### Superset 본체

- `apache/superset`에 `good_first_issue` 라벨 0건
- 메가 organization, 회전율 빠름
- 회피

## 본인 운영 발견 후보

1. **Cross-origin iframe + SameSite cookie + Superset 로그인**
   - 본인 commit `8c31f61` "server-side admin auto-login to bypass cross-origin cookie block"
   - 본인 Next.js proxy 디자인 이슈 (Superset bug 아님)
   - upstream 부적합

2. **Superset iframe embed docs**
   - 본인이 cross-origin + Content-Encoding/Content-Length/X-Frame-Options 모두 strip해야 작동
   - Superset docs에 iframe embed best practice 명시 부재 가능
   - 검증 후 docs PR 가능성

## 참고

- 공식 사이트: https://superset.apache.org
- GitHub: https://github.com/apache/superset
- 라이선스: Apache 2.0
- Apache 프로젝트 (ICLA 필요)

## 본인 사용 패턴

- TwinX `argocd/trident/apps/superset/`
- Trident-Portal `/api/superset/[...path]/route.ts` reverse proxy
- Trino datasource (Iceberg metadata 포함)
- 본인 c9c6f54 "use RGW admin credentials for all-bucket S3 access" 운영 경험
