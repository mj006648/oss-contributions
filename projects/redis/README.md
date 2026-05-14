# Redis

Trident가 Redis를 Storage Search 캐시로 사용. Iceberg manifest를 ReJSON 구조로 캐싱, BM25 검색 (Hybrid search RRF).

## 정찰 결과 (2026-05-14)

### Redis 본체

- `redis/redis` 저장소에 `good first issue` 라벨 0건
- 메가 organization, 외부 contributor 진입 매우 어려움
- 회피

### redis-py (Python client)

- 본인 사용 `redis==5.0.8`
- 추가 정찰 필요 (다음 세션)

## 본인 운영 발견 후보

- 본인 commit `f787055` "fix Redis key pattern and add schema_config cleanup" — 본인 코드 디자인 이슈, upstream 부적합
- 본인 commit `f2fa144` "inject REDIS_PASSWORD into Spark driver/executor via trident-redis-creds secret" — Spark + Redis 인증 패턴, 본인 환경 의존

진짜 upstream 가능한 발견 없음.

## 참고

- redis/redis: https://github.com/redis/redis (C)
- redis/redis-py: https://github.com/redis/redis-py (Python)
- redis/node-redis: https://github.com/redis/node-redis
- 메가 organization

## 본인 사용 패턴

- TwinX `argocd/iceberg/apps/redis/`
- ReJSON 모듈 (Iceberg manifest 캐싱)
- BM25 검색 (en_keywords, ko_keywords)
- RRF hybrid score (Milvus COSINE + Redis BM25)
