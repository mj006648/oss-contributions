# Nessie #5349 — Cloud Object Storage 일관성 문서 업데이트

- 원본 이슈: https://github.com/projectnessie/nessie/issues/5349
- 보고자: @shawnweeks (Shawn Weeks)
- 보고일: 2022-10-10
- 라벨: good first issue
- 상태: 분석 완료, 문서 위치 확인 후 수정 단계 대기

## 이슈 본문 요약 (원문 인용)

> Not really sure where to put this but I see several mentions in Nessie documentation about having to work around eventual consistency issues when using object storage. It should be noted that as of December 2020 S3 provides strong read after write consistency and so does the Google equivalent.
>
> See https://aws.amazon.com/s3/consistency/ and https://cloud.google.com/storage/docs/consistency

핵심:
- Nessie 문서 곳곳에 "객체 스토리지는 eventual consistency라서 우회가 필요하다"는 내용이 있다.
- 그러나 **2020년 12월부터 AWS S3는 strong read-after-write consistency 제공**.
- GCS도 처음부터 strong consistency.
- Azure Blob도 strong consistency.
- → 문서가 outdated. 수정 필요.

## 작업 방향

1. Nessie 저장소 내 `site/` 디렉터리(MkDocs 추정) 또는 `README.md`에서 다음 키워드 grep:
   - `eventual consistency`
   - `eventually consistent`
   - `cloud object storage` + consistency 문맥
   - `S3` 와 함께 `consistent`/`consistency`
2. 각 발견 지점에 대해:
   - 기술적으로 outdated인지 (대부분 그럴 것)
   - 역사적/설명 맥락에서 보존이 필요한지
3. 수정안:
   - "S3는 eventual consistency라서 ..." → "Historically S3 had eventual consistency before December 2020; current S3 provides strong read-after-write consistency. Nessie still ..." 형태로 유지하거나
   - 우회 로직이 더 이상 필요 없다면 해당 설명 자체를 제거하거나 historical note로 강등
4. 외부 레퍼런스 링크 갱신:
   - https://aws.amazon.com/s3/consistency/
   - https://cloud.google.com/storage/docs/consistency

## 작업 체크리스트

- [x] 이슈 본문 정독
- [x] 사실관계 확인 (S3 2020-12 strong consistency, GCS·Azure 전부 strong consistency)
- [ ] Nessie repo fork & clone
- [ ] `site/` 내 "consistency" grep
- [ ] 영향 받는 페이지 목록화
- [ ] 각 페이지별 수정안 작성
- [ ] mkdocs 로컬 빌드 (`mkdocs serve`) 확인
- [ ] 변경 diff 검토
- [ ] PR 초안 작성
- [ ] DCO sign-off 커밋
- [ ] PR 제출

## 사실관계 레퍼런스

| 사업자 | strong consistency 시점 | 출처 |
|--------|------------------------|------|
| AWS S3 | 2020-12-01부터 | https://aws.amazon.com/s3/consistency/ |
| GCS    | 처음부터 (since launch) | https://cloud.google.com/storage/docs/consistency |
| Azure Blob | 처음부터 (since launch) | https://learn.microsoft.com/azure/storage/blobs/concurrency |

## 주의

- 2022년 이슈이고 댓글이 없어 maintainer가 잊었을 가능성. PR 올리기 전에 Zulip 또는 issue 댓글로 "Working on this, intended scope: ..." 한 줄 남기는 게 안전.
- 문서 PR은 보통 빠르게 머지되지만, "consistency model 보장"은 Nessie 내부 로직과도 얽혀 있을 수 있어, 단순 단어 치환이 아닌 "여전히 우회가 필요한 부분이 있다면 그 이유"를 별도 섹션으로 정리해주는 것이 더 가치 있을 수 있다.
