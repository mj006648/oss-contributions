# PyIceberg (apache/iceberg-python)

[PyIceberg](https://github.com/apache/iceberg-python)는 Apache Iceberg의 Python 바인딩. Trident의 Stats Service(FastAPI)가 ingest/audit/CTAS 경로에서 PyIceberg를 통해 Iceberg table을 직접 조작.

## 기여 후보 정찰 결과

| 이슈 | 제목 | 상태 | 평가 |
|------|------|------|------|
| [#1310](https://github.com/apache/iceberg-python/issues/1310) | `@typing.override` 추가 | 3명이 "할게요" 댓글 → 모두 stale | 회피 (혼잡) |
| [#1191](https://github.com/apache/iceberg-python/issues/1191) | `pyiceberg/table/inspect.py` docstrings | stale | 후속 정찰 |
| [#1169](https://github.com/apache/iceberg-python/issues/1169) | Time64Type[ns] 지원 | @zaryab-ali assigned, 여러 stale PR | 회피 (정치적 상황) |
| [#1008](https://github.com/apache/iceberg-python/issues/1008) | DOCS: Write Support 문서 | @pramila-bishnoi 진행 중 | 회피 |
| [#818](https://github.com/apache/iceberg-python/issues/818) | View support in REST Catalog | 큰 feature | 보류 |

## 진행 중

(아직 없음 — 인기 프로젝트로 충돌 위험 높음. 본인 연구 중 발견한 버그로 직접 진입 검토 권장)

## 참고 링크

- [PyIceberg GitHub](https://github.com/apache/iceberg-python)
- [Contributing Guide](https://github.com/apache/iceberg-python/blob/main/CONTRIBUTING.md)
- Apache ICLA 서명 필요
- Slack: ASF Slack `#iceberg-python`

## 개발 환경 메모

- 언어: Python
- 빌드: `poetry install`
- 로컬 clone 예정 경로: `~/chang/Git/iceberg-python` (필요 시)
- 본인이 매일 쓰는 라이브러리라 실사용 버그/문서 부족 발견 가능성 높음
