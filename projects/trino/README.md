# Trino

Trident analytics router(`routers/analytics.py`)가 Trino REST API 직접 사용. 본인 운영 패턴:
- `X-Trino-User: trident` header
- `/v1/statement` 폴링 (200회, timeout 120s)
- Iceberg connector + Nessie catalog

## 정찰 결과 (2026-05-14)

### 회피 (작업자 있음 또는 결정 미정)

| 이슈 | 회피 이유 |
|------|---------|
| [#28765](https://github.com/trinodb/trino/issues/28765) truncate(number, position) docs | PR #28771 이미 제출 (KJyang-0114) |
| [#24175](https://github.com/trinodb/trino/issues/24175) extract field docs | mosabua가 @jhlodin, @Lukashmoser 두 명에 작업 요청 |
| [#28999](https://github.com/trinodb/trino/issues/28999) Delta Lake OPTIMIZE metrics | Delta Lake 영역, 본인 미사용 |
| [#28076](https://github.com/trinodb/trino/issues/28076) CREATE VIEW IF NOT EXISTS | 본인 친숙, 작업자 확인 필요 |
| [#27512](https://github.com/trinodb/trino/issues/27512) access public S3 anonymously | 본인 Ceph S3 친숙 |

### 본인 운영 발견 후보 (검증 후 등록)

1. **Trino REST API trailing semicolon 처리**
   - 본인 commit `18fa244`에서 SQL trailing semicolon strip 처리
   - Trino `/v1/statement`에 semicolon 포함 SQL 보내면 에러
   - docs에 명시 부재 (확인 필요)
   - 새 이슈 또는 docs PR 가능성

2. **Trino REST API polling iteration 표준**
   - 본인 commit `c061bf3`에서 폴링 30 → 200, timeout 30 → 120s
   - docs에 권장 폴링 횟수/timeout 명시 부재
   - **본인 환경 의존성 높아 upstream 부적합 가능**

## 참고

- 공식 사이트: https://trino.io
- Contributing: https://trino.io/development/process.html
- Slack: trinodb.slack.com
- 메가 organization (Starburst 주도 + 다수 maintainer)
- `good first issue` 회전율 빠름

## 본인 사용 패턴

- `routers/analytics.py:_trino_query()` 함수
- Iceberg + Nessie catalog 연동 (`trident.namespace.table`)
- NL2SQL (Ollama qwen2.5-coder)
- BI Dashboard (Superset 연동)
