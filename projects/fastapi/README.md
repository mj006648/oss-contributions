# FastAPI

Trident Stats Service가 FastAPI 0.115. 본인 매일 사용.

## 정찰 결과 (2026-05-14)

### fastapi/fastapi (본체)
- `good first issue` 라벨: **0건**
- `feature reviewed` 라벨 일부 (큰 작업):
  - #3317 lazy initialize OAuth2 classes
  - #1773 HEAD method 자동 지원
  - #617 startup/shutdown events 추가 개발
- 진입 어려움

### fastapi/typer, fastapi/sqlmodel
- 라벨 검색 결과 없음

### 핵심 관찰

**FastAPI는 한 명 메인테이너(@tiangolo) 중심**: PR 머지 매우 느림 (수개월 묵힘 흔함). 라벨 체계 단순.

## 진입 전략

직접 진입 어려움. 우회:
1. **Trident Stats Service 개발 중 발견한 FastAPI 패턴 docs 부족**을 새 이슈로 등록
2. fastapi/fastapi/docs_src/ 예제 추가 PR (Iceberg/Nessie 연동 등)
3. Sub-project (sqlmodel, fastapi-users) 정찰

## 본인 사용 패턴 (이슈 후보 발굴 자료)

- async + Keycloak OIDC middleware 결합
- Trino REST API client wrapping
- pymilvus async 호출 시 패턴
- PostgreSQL psycopg2 async 패턴

위 영역에서 docs 부족 또는 example 부재 발견 시 → 새 이슈 등록 후보.

## 참고

- 라이선스: MIT
- CLA: 별도 서명 불필요 (License만 동의)
- 메인테이너 @tiangolo (Sebastián Ramírez)
