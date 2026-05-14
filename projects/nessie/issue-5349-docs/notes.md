# Nessie #5349 — Cloud Object Storage 일관성 문서 업데이트

- 원본 이슈: https://github.com/projectnessie/nessie/issues/5349
- 상태: 초안 작성
- 시작일: 2026-05-14

## 이슈 요약 (TBD)

원문 제목: "Doc Update - Cloud Object Storage Consistency"

S3/GCS/Azure Blob 등 객체 스토리지 일관성 모델 관련 문서 갱신이 필요하다는 이슈로 추정. 본문 정독 후 정리.

## 분석 체크리스트

- [ ] 이슈 본문 정독
- [ ] 현재 문서 위치 확인 (`site/docs/` 또는 유사 경로)
- [ ] 어떤 부분이 outdated인지 식별
- [ ] AWS S3 strong consistency(2020년 이후) 반영 필요 여부 확인
- [ ] 변경안 초안 작성
- [ ] 로컬에서 mkdocs 빌드 확인
- [ ] PR 초안 작성
- [ ] DCO sign-off 커밋
- [ ] PR 제출

## 변경 방향

(분석 후 작성)

## 참고

- AWS S3는 2020-12부터 strong read-after-write consistency 제공
- GCS는 처음부터 strong consistency
- 과거 문서가 eventual consistency를 가정했다면 갱신 필요
