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
1. CPython 사용 중 docs 부족 발견을 새 이슈로 등록 (예: asyncio + psycopg2 패턴)
2. python/devguide/contrib/ 예제 추가
3. python/peps 새 PEP 작성 (큰 작업)

## 다음 세션 진입 후보 (정찰 완료 2026-05-14)

devguide 영역, 본인 친숙 + 작업자 없음:

| 이슈 | 평가 | 진입 가능성 |
|------|------|---------|
| [#1791](https://github.com/python/devguide/issues/1791) Homebrew dependency docs (Linux) | docs feature | 후보 |
| [#1790](https://github.com/python/devguide/issues/1790) Build dependency tabs | docs feature | 후보 |
| [#1786](https://github.com/python/devguide/issues/1786) GitHub Actions re-run on PRs docs | docs | 본인 친숙 |
| [#1669](https://github.com/python/devguide/issues/1669) pixi 시스템 의존성 가이드 | docs feature | 후보 |
| [#1594](https://github.com/python/devguide/issues/1594) Triager 가이드 명확화 | docs | 본인 친숙

## 참고

- 라이선스: PSF License
- CLA: PSF Contributor Agreement 필요
- 토론: discuss.python.org
- core developer 승격: PR 5~10개 + 기존 core developer 추천
