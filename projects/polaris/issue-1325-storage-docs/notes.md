# Polaris #1325 — Document Polaris with different cloud storage backends

- 원본 이슈: https://github.com/apache/polaris/issues/1325
- 등록일: 2025-04-06
- 라벨: documentation, enhancement, good first issue
- assignee: 없음
- maintainer 컨택: @flyrain (Yufei Gu, Snowflake, Polaris PMC member)

## 이슈 본문 요약

`polaris.apache.org/in-dev/unreleased/configuration/`와 `overview/#storage-configuration` 페이지가 S3/Azure Blob/GCS 각 storage backend 설정 방법을 충분히 설명하지 않는다. 전용 페이지가 필요.

## 진행 타임라인

- 2025-04-06: 이슈 등록
- 2025-04-24: @iihimanshuu PR 제안
- 2025-04-24: @adnanhemani PR #1435 제출
- 2025-05-05: PR #1435 머지 (quickstart-deploy 파일 추가)
- 2025-05-05: @flyrain — 더 많은 storage backend docs 필요 명시
- 2026-05-14 03:10: 본인 의도 코멘트 게시 (잘못된 가정: Azure Blob + GCS 필요)
- 2026-05-14 05:56: @flyrain 응답 — system admin end-to-end perspective, server + client 둘 다, skill.md 옵션 제안
- 2026-05-14 07:14: 본인 확인 코멘트 게시 (잘못된 범위 유지)
- 2026-05-14 (당일): Polaris fork & clone, 실제 코드 구조 파악
- 2026-05-14: 본인 보완 코멘트 게시 (옵션 1 vs 옵션 2 명시 요청)

## 실제 Polaris docs 구조 (2026-05-14 확인)

이미 존재:
- `getting-started/deploying-polaris/cloud-deploy/quickstart-deploy-aws.md` (PR #1435)
- `getting-started/deploying-polaris/cloud-deploy/quickstart-deploy-azure.md` (PR #1435)
- `getting-started/deploying-polaris/cloud-deploy/quickstart-deploy-gcp.md` (PR #1435)
- `configuration/configuring-polaris-for-production/configuring-gcs-cloud-storage-specific.md` (33줄, server-side only)

빠진 부분 (production configuration):
- `configuring-aws-s3-cloud-storage-specific.md` — 없음
- `configuring-azure-blob-cloud-storage-specific.md` — 없음

기존 GCS 페이지 본문 (참조 패턴):
- frontmatter + title
- 개요 1문단 (credential vending)
- IAM + HNS ACL 주의사항
- HNS 옵션 안내
- 총 33줄, 매우 짧음

## maintainer @flyrain 응답 핵심 (2026-05-14)

> "Thanks for picking this up, @mj006648. My idea is to provide end to end instructions that include both Polaris server side and client side configuration for different object storage systems, including AWS S3, Azure, and GCS. What you described here is already pretty close. I'm thinking from the perspective of a system admin who wants to set up Polaris with a specific storage backend. The docs should clearly describe the recommended setup process from start to finish. Beside a doc, another option could be to provide a skill.md so an agent can help automate the setup process."

요구사항:
1. System admin 관점 end-to-end
2. Server side + client side 둘 다
3. AWS S3, Azure, GCS 셋 다 다룸 (GCS 기존 페이지 확장 가능성)
4. skill.md 옵션 추가 (AI agent 자동화)

## 옵션 1 vs 옵션 2 (본인이 maintainer에 질문)

옵션 1 — minimal gap fill:
- AWS S3, Azure Blob 페이지 2개 추가 (기존 GCS 페이지 패턴, server-side만)
- client-side wiring과 skill.md는 별도 follow-up
- 작업량: 본인 3~6시간 추정

옵션 2 — full E2E guide:
- backend별 페이지 (server config + client connection + verification 통합)
- 기존 GCS 페이지도 확장해서 매칭
- skill.md follow-up
- 작업량: 본인 10~20시간 추정

## 본인 연구 연관성

- Trident가 Ceph S3(현재) + Azure/GCS(계획)를 모두 다루는 멀티 클라우드 Lakehouse
- 본인 KubeCon Japan 2025 발표 + master-thesis multi-cloud 컨셉과 직결
- AWS S3는 본인 직접 운영 경험 (Ceph S3 호환)
- Azure / GCS는 본인 학습 + 공식 docs 참고 필요

## 작업 체크리스트

- [x] 이슈 본문 정독
- [x] 진행 상황 파악 (PR #1435 부분 머지)
- [x] 의도 코멘트 게시 (https://github.com/apache/polaris/issues/1325#issuecomment-4447111795)
- [x] maintainer @flyrain 응답 받음 (system admin end-to-end + server/client + skill.md)
- [x] 본인 확인 코멘트 게시 (https://github.com/apache/polaris/issues/1325#issuecomment-4448535662)
- [x] Polaris repo fork (mj006648/polaris) & clone (`~/chang/Git/polaris`)
- [x] upstream remote 설정
- [x] 실제 docs 구조 정찰 (production config 위치 + 기존 GCS 페이지 패턴)
- [x] 보완 코멘트 게시 (옵션 1 vs 옵션 2 질문)
- [x] @flyrain 응답 대기 (옵션 1/2 선택) — **옵션 1 확정 (2026-05-15)**
- [x] 옵션 1 작성: AWS S3 + Azure Blob production config 페이지 2개
  - [x] draft 초안 (oss-contributions/projects/polaris/issue-1325-storage-docs/)
  - [x] polaris fork에 브랜치 생성 + 파일 이식 — `docs/1325-aws-s3-azure-blob-storage`
  - [x] hugo 빌드 로컬 검증 (186 pages, 에러 0)
- [x] end-to-end 검증
  - [x] MinIO + Polaris + Spark: CREATE/INSERT/SELECT 성공
  - [x] MinIO + Polaris + Trino: CREATE/INSERT/SELECT 성공 → 누락 properties 발견·반영
  - [x] MinIO + Polaris + PyIceberg 0.11.1: append/scan 성공 → 누락 옵션 발견·반영
  - [x] Ceph RGW + Polaris: STS 미지원 발견 (`Failed to get subscoped credentials` STS 400) → S3-compatible endpoints 섹션 STS 분기로 재작성
  - [x] ADLS Gen2 (HNS on) + SP + Polaris + Spark: 성공
  - [x] ADLS Gen2 RBAC 제거 후: `AuthorizationPermissionMismatch` 403 정확 재현 → Azure 트러블슈팅 메시지 보강
- [x] ICLA 서명 (Apache Individual CLA) — 2026-05-15 secretary@apache.org 제출, 승인 회신 대기
- [x] DCO sign-off 커밋
- [x] Draft PR 제출 — apache/polaris#4451 (2026-05-15)
- [x] CI 통과 — 24개 check 전부 SUCCESS (2026-05-15)
- [x] 1차 리뷰 수령 — @dimas-b 인라인 코멘트 14개 (2026-05-15)
- [x] 1차 리뷰 대응 commit `f5eae4e` (2026-05-16) — S3 페이지 제목 변경, `userArn`/STS 모순/KMS 문구 정정, Azure HNS 의미 재작성, `multiTenantAppName` informational 표기
- [x] PR 답글 작성 — Trino S3 block 추가 검증 가능성 reviewer에 질문

## 검증 환경 정리 기록

| 자원 | 상태 |
|---|---|
| Azure RG `polaris-test-rg` | 삭제 (`--no-wait`) |
| Azure RG `polaris-acl-test-rg` | 삭제 (`--no-wait`) |
| Azure SP `polaris-storage-test` / `polaris-acl-test` | 모두 삭제, app도 삭제 |
| `az logout` | 완료, `~/.azure-cli-home` 제거 |
| MinIO + Polaris + Trino 컨테이너 | 모두 down -v |
| Polaris+Ceph 컨테이너 | down |
| Polaris+Azure 컨테이너 (Phase A/B) | down |
| `/tmp/*-verify*` 임시 파일 | 삭제 |

## 참고

- Polaris fork 위치: https://github.com/mj006648/polaris
- 로컬 clone: `/home/netai/chang/Git/polaris`
- PR 브랜치: `docs/1325-aws-s3-azure-blob-storage` (4 커밋)
- Apache ICLA 서명 사이트: https://www.apache.org/licenses/contributor-agreements.html
- 첫 Apache PR이라 ICLA 신규 서명 필요
