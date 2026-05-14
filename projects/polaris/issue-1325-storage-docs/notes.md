# Polaris #1325 — Document Polaris with different cloud storage backends

- 원본 이슈: https://github.com/apache/polaris/issues/1325
- 등록일: 2025-04-06
- 라벨: documentation, enhancement, good first issue
- assignee: 없음
- 상태: 부분 머지 (PR #1435), 나머지 storage backend 문서 필요

## 이슈 본문 요약

`polaris.apache.org/in-dev/unreleased/configuration/`와 `overview/#storage-configuration` 페이지가 S3/Azure Blob/GCS 각 storage backend 설정 방법을 충분히 설명하지 않는다. 전용 페이지가 필요.

## 진행 상황

- 2025-04-24: @iihimanshuu가 PR 제안
- 2025-04-24: @adnanhemani가 PR #1435 제출 (Spark + S3 중심)
- 2025-05-05: PR #1435 머지됨
- 2025-05-05: maintainer @flyrain — "오프라인 논의 결과 다른 storage backend(Azure Blob, GCS) 문서 더 필요"
- 이후 추가 작업 없음

즉 **이슈는 부분 해결, 나머지 Azure Blob + GCS 문서가 비어있는 상태**.

## 우리 접근 방향

PR #1435가 다룬 부분(S3 + Spark) 외에:

1. **Azure Blob Storage** 설정 페이지
   - storage configuration JSON 예시
   - tenant ID, client ID, client secret 또는 Workload Identity
   - ADLS Gen2 endpoint 형식
   - Vended Credentials 동작 (참고: #418)
2. **Google Cloud Storage** 설정 페이지
   - service account 키 또는 Workload Identity
   - bucket-level vs uniform IAM
   - GCS HMAC vs ADC 방식
3. 각 backend가 Polaris의 `STORAGE_CONFIG_INFO`에 매핑되는 방식
4. Spark/Trino/PyIceberg 클라이언트에서 각 backend 사용 시 의존성 (ex: hadoop-azure, hadoop-aws, gcs-connector)

## 본인 연구 연관성

Trident가 Ceph S3(현재) + Azure/GCS(계획)를 모두 다루는 멀티 클라우드 Lakehouse라 직접 활용. 본 연구 중 실제로 마주칠 설정 이슈를 문서화하는 셈.

## 주의

- PR #1435 머지로 일부 해결됐기 때문에 **이슈는 닫혀있을 수 있음**. 우선 현재 open 상태 재확인 후 진행.
- Apache 프로젝트는 ICLA 서명 필요.
- maintainer @flyrain가 명시적으로 "더 필요"라 했으므로 새 PR 환영 가능성 높음.

## 작업 체크리스트

- [x] 이슈 본문 정독
- [x] 진행 상황 파악 (PR #1435 부분 머지)
- [ ] 이슈 현재 open/closed 상태 확인
- [x] 의도 코멘트 게시 (https://github.com/apache/polaris/issues/1325#issuecomment-4447111795)
- [ ] Polaris repo fork & clone
- [ ] `site/`(또는 docs 디렉터리) 구조 확인
- [ ] PR #1435 머지 commit 보고 작성 형식 참고
- [ ] 응답 받으면 작업 진행
- [ ] ICLA 서명
- [ ] DCO sign-off 커밋
- [ ] PR 제출
