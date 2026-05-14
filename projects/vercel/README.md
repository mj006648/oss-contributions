# Vercel (Next.js)

Trident-Portal이 Next.js 기반이라 본인 친숙도 매우 높음.

## 정찰 결과 (2026-05-14)

| 이슈 | 평가 |
|------|------|
| next.js #42846 `AppType` parameter 잘못 사용 | **회피** — 4개 open PR 경쟁 중 (#85293, #87846, #84424, #86935), 21개 댓글 줄 서기 |
| next.js #41281 getStaticPaths 에러 메시지 일관성 | **회피** — 3년째 묵힘, 다수 PR 제출/방치, maintainer 응답 없음 |
| next.js #53473 `no-html-link-for-pages` + pageExtensions | 후속 정찰 가능 |
| next.js #15971 Redux-observable example | 2017년 묵힘, 비현실적 |

## 핵심 발견

**Next.js는 가장 인기 메가 organization**: `good first issue` 등록 즉시 5~20명 줄 섬. 첫 PR 사실상 머지 0%.

## 진입 전략

직접 issue 진입 거의 불가능. 우회:
1. **Trident-Portal 운영 중 발견한 Next.js 버그**를 새 이슈로 등록
2. `vercel/next.js/examples/` 디렉터리에 **본인 사용 예제**(Iceberg 또는 Keycloak 연동 등) 추가하는 PR
3. docs/typo 발견 시 작은 PR (예: nextjs.org/docs 오타)

## 참고

- 라이선스: MIT
- CLA: 첫 PR 시 봇 안내
- Vercel 직원 maintainer 다수, 응답 빠른 편 (단 인기 이슈는 무시됨)
