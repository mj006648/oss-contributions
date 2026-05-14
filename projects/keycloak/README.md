# Keycloak

Trident Identity Plane = Keycloak. 본인이 trident realm 운영, OIDC + role/group claim 발급, Trident-Portal과 Stats Service가 JWT 검증.

## 정찰 결과 (2026-05-14)

### 회피 (assigned 또는 활성 작업)

| 이슈 | 회피 이유 |
|------|---------|
| [#33018](https://github.com/keycloak/keycloak/issues/33018) Documentation placeholder syntax | @vil2be assigned + 12 코멘트 활성 |
| [#41640](https://github.com/keycloak/keycloak/issues/41640) NullPointerException after 26.3.2 | 본인 영역 외 |
| [#32979](https://github.com/keycloak/keycloak/issues/32979) Browser router admin ui | UI 영역, 본인 미숙 |
| [#32640](https://github.com/keycloak/keycloak/issues/32640) Username validator on LDAP import | 본인 LDAP 미사용 |

## 본인 운영 발견 후보

- realm/role/group 운영 중 발견할 docs gap (예: OIDC + PostgreSQL access policy 통합 사례)
- 본인이 Trident에서 Keycloak token → FastAPI middleware → PostgreSQL access_policies 매핑 운영
- 이 통합 패턴이 Keycloak docs에 명시되어 있지 않을 수 있음

## 참고

- 공식 사이트: https://www.keycloak.org
- GitHub: https://github.com/keycloak/keycloak
- 라이선스: Apache 2.0
- 메가 organization, 다수 maintainer
- `good first issue` 다수지만 회전율 빠름

## 본인 사용 패턴

- TwinX `argocd/iceberg/apps/keycloak/`
- trident realm + 5개 role (admin/operator/researcher/viewer/service)
- 5개 group (/trident/admins, /trident/operators, /trident/researchers, /trident/viewers, /trident/services)
- JWT claim: `realm_access.roles`, `groups`
