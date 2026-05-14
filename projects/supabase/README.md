# Supabase

[Supabase](https://github.com/supabase/supabase)는 Firebase의 오픈소스 대안. PostgreSQL 위에 GoTrue(auth), PostgREST, Realtime(LISTEN/NOTIFY), Storage(S3 호환), pgvector를 얹은 BaaS. 본인 Trident가 PostgreSQL + Keycloak + FastAPI + Milvus + Ceph로 유사한 설계 → 친숙도 매우 높음.

## 기여 후보 정찰 결과 (2026-05-14)

| 이슈 | 제목 | 상태 | 평가 |
|------|------|------|------|
| [supabase/supabase #6435](https://github.com/supabase/supabase/issues/6435) | Allow newlines in SMS OTP template | 2026-05-02 신선, frontend+auth | 후속 정찰 후보 |
| [supabase/auth #880](https://github.com/supabase/auth/issues/880) | Create `supabase.auth.admin.getUserByEmail` | **회피** — maintainer가 명시적으로 거절(`listIdentitiesForEmailAddress`로 대체 예정), 7명 줄 섬, 모두 stale | Skip |
| [supabase/auth #263](https://github.com/supabase/auth/issues/263) | POST `/admin/generate_link` empty when SMTP env unset | hacktoberfest, SMTP env 처리 Go 코드 | 후속 정찰 후보 |

postgres-meta 등 다른 sub-project는 `good first issue` 라벨 0건.

## 다음 세션 진입 후보 (docs 영역, 정찰 완료 2026-05-14)

| 이슈 | 평가 | 진입 가능성 |
|------|------|---------|
| [supabase/supabase #42997](https://github.com/supabase/supabase/issues/42997) Auth Audit Logs ip_address docs | @m7amedenho 작업 중 + 다수 자원자 | 회피 |
| [#45051](https://github.com/supabase/supabase/issues/45051) Redirection URL code parameter docs | to-triage, 작업자 없음 | 후보 |
| [#43920](https://github.com/supabase/supabase/issues/43920) Drizzle connection snippet host 변수 오류 | to-triage | 후보 |
| [#43164](https://github.com/supabase/supabase/issues/43164) NextJS15→16 broken patterns | to-triage, 본인 검증 어려움 | 보류 |

## 첫 진입 어려움 분석

- supabase/supabase 본체: 인기 메가 프로젝트 → `good first issue` 회전율 높음 (Apache PyIceberg와 유사 양상)
- supabase/auth: 정치 복잡 (#880 패턴), SSO identity 모델 이해 필수
- 다른 sub-project (postgres-meta, realtime, storage, pg_graphql): `good first issue` 적음

진입 전략 다음 단계 (다음 세션):
- `supabase/auth #263` 본문 + SMTP 처리 코드 정찰
- `supabase/supabase #6435` SMS template parser 위치 정찰
- 또는 본인 Trident-Portal에서 Supabase Studio(Next.js dashboard) 보면서 발견한 UX 이슈 직접 등록

## 참고 링크

- [Supabase main repo](https://github.com/supabase/supabase)
- [supabase/auth (GoTrue)](https://github.com/supabase/auth)
- [supabase/postgres-meta](https://github.com/supabase/postgres-meta)
- [Contributing Guide](https://github.com/supabase/supabase/blob/master/CONTRIBUTING.md)
- 라이선스: Apache 2.0 (core), BSL (일부 enterprise)
- DCO sign-off 필요

## 본인 연구 연관성

| Supabase 컴포넌트 | Trident 대응 |
|------------------|------------|
| PostgreSQL | PostgreSQL Catalog Plane |
| GoTrue (auth) | Keycloak OIDC |
| PostgREST | FastAPI Stats Service |
| pgvector | Milvus |
| Storage (S3 호환) | Ceph RGW |
| Realtime (LISTEN/NOTIFY) | (미사용) |

본인 연구가 "Supabase의 데이터 레이크하우스 버전"이라고도 볼 수 있음.
