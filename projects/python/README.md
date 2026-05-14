# Python

Trident Stats Service + Spark scripts 모두 Python 3.12. CPython 본체보다 sub-project로 진입.

## 정찰 결과 (2026-05-14)

### python/devguide (Python 기여자 가이드)
| 이슈 | 평가 |
|------|------|
| #1286 bytecode specialization docs | **회피** — 다수 시도, @faizanoor3001 PR stuck, maintainer가 InternalDocs로 옮기는 방향 미정 |
| #1243 NEWS/What's New examples | 후속 정찰 |
| #931 Making Good PRs section | 후속 정찰 |

### python/typing
- `good first issue` 라벨: 0건
- `documentation` 라벨: 정찰 결과 없음

### python/cpython (본체)
- 너무 크고 PEP 절차 필요 → 첫 기여 부적합

## 핵심 발견

**Python은 CPython 본체보다 sub-repo가 진입 가능**: devguide, peps, typing 정도가 안전. 다만 인기로 인해 줄 서기.

## 진입 전략

직접 진입 어려움. 우회:
1. **CPython 사용 중 docs 부족 발견**을 새 이슈로 등록 (예: asyncio + psycopg2 패턴)
2. python/devguide/contrib/ 예제 추가
3. python/peps 새 PEP 작성 (큰 작업)

## 참고

- 라이선스: PSF License
- CLA: PSF Contributor Agreement 필요
- 토론: discuss.python.org
- core developer 승격: PR 5~10개 + 기존 core developer 추천
