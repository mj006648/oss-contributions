# Milvus / PyMilvus

Trident Stats Service가 `pymilvus==2.4.9` 사용 (semantic search). Search router에서 collection load + vector search + RRF hybrid 패턴.

## 진행 중

- [pymilvus #2724 코멘트](https://github.com/milvus-io/pymilvus/issues/2724#issuecomment-4448976704) — 본인 production 환경에서 setuptools 82.x로 인한 hard failure 데이터 포인트 추가

## 정찰 결과 (2026-05-14)

| 이슈 | 평가 |
|------|------|
| [milvus #47964](https://github.com/milvus-io/milvus/issues/47964) RAG failure modes docs | @onestardao assigned — 회피 |
| [milvus #44635](https://github.com/milvus-io/milvus/issues/44635) HNSW_SQ Go client | feature, Go 영역 — 보류 |
| [milvus #39157](https://github.com/milvus-io/milvus/issues/39157) Search by ID | feature, 본인 친숙 가능 |
| [milvus #39629](https://github.com/milvus-io/milvus/issues/39629) Arithmetic operations between fields | enhancement |
| [pymilvus #685](https://github.com/milvus-io/pymilvus/issues/685) "Pick an issue and become a contributor" | 2022년 메타 이슈, 회피 |

## 본인 운영 발견 후보 (검증 후 등록 검토)

본인 commit log에서 발견한 잠재 버그:

1. **non-default connection alias 자동 사용 안 됨**
   - `connections.connect(alias="X", ...)` 후 `Collection("name")` 호출 시 alias 자동 사용 X
   - `using="X"` 명시 안 하면 default 찾음 → silent failure
   - 본인 commit `8426540`에서 `using="search_conn"` 추가로 해결
   - 검증 필요: 의도된 동작인지, docs gap인지
   - pymilvus 3.0.0에서 동작 동일한지 확인 필요

2. **pkg_resources 의존성 충돌 (이미 #2724에 코멘트 추가)**

## 참고

- 공식 사이트: https://milvus.io
- pymilvus GitHub: https://github.com/milvus-io/pymilvus
- milvus core: https://github.com/milvus-io/milvus
- Slack/Discord: milvus.io community
- CLA: 별도 서명 (LF AI & Data Foundation)

## 본인 사용 패턴

- 본인 `stats-service/main.py` `_milvus_search_sync()` 함수
- collection: `trident_semantic_catalog`
- search params: `metric_type=COSINE`, `nprobe=10`
- bge-m3 임베딩 (3 layer Super Context)
