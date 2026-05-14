# Project Nessie

[Project Nessie](https://github.com/projectnessie/nessie)는 Apache Iceberg 등 오픈 테이블 포맷을 위한 Git-style 트랜잭션 카탈로그다. Trident Lakehouse에서 Iceberg 테이블의 commit/branch/tag 관리를 담당하는 핵심 구성요소이며, 본 연구의 PostgreSQL 기반 Governance Plane이 Nessie 백엔드와 동일 PostgreSQL 인스턴스를 공유한다.

## 기여 목표

1. 연구 사용 중 발견한 실제 불편함을 upstream으로 환원
2. DCO 기반 PR 프로세스 체득
3. 첫 머지 경험 → 이후 Iceberg/ArgoCD로 확장

## 활동 목록

| 이슈/PR | 제목 | 상태 | 폴더 |
|---------|------|------|------|
| [#10865](https://github.com/projectnessie/nessie/issues/10865) | CLI STDOUT redirect 버그 | 분석 중 | [issue-10865-cli-stdout/](./issue-10865-cli-stdout/) |
| [#5349](https://github.com/projectnessie/nessie/issues/5349)   | Cloud Object Storage 일관성 문서 업데이트 | PR #12424 제출, CLA 통과, 리뷰 대기 | [issue-5349-docs/](./issue-5349-docs/) |
| [#12424](https://github.com/projectnessie/nessie/pull/12424) | PR: docs update for #5349 | 리뷰 대기 | - |

## 다음 세션 진입 후보 (정찰 완료 2026-05-14)

| 이슈 | 평가 | 진입 가능성 |
|------|------|---------|
| [#4371](https://github.com/projectnessie/nessie/issues/4371) commit kernel docs 업데이트 | 2022년 등록, 작업자 없음 | 후보 (구버전 문서) |
| [#5325](https://github.com/projectnessie/nessie/issues/5325) CEL filter docs | maintainer 의견 미정 (snazy, dimas-b) | 회피 (방향 미합의) |

## 참고 링크

- [Nessie GitHub](https://github.com/projectnessie/nessie)
- [Contributing Guide](https://github.com/projectnessie/nessie/blob/main/CONTRIBUTING.md)
- [Zulip Chat](https://project-nessie.zulipchat.com/)
- DCO 방식 (CLA 별도 서명 불필요, `git commit -s`로 sign-off)

## 개발 환경 메모

- 언어: Java (Quarkus 기반)
- 빌드: Gradle
- 로컬 clone 예정 경로: `~/chang/Git/nessie`
