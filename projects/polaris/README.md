# Apache Polaris

[Apache Polaris](https://github.com/apache/polaris)는 Apache Iceberg를 위한 오픈 카탈로그 서비스다. 2024년 Snowflake가 기증하여 Apache 인큐베이션에 진입했으며 비교적 신생 프로젝트라 커뮤니티가 한산하다. Trident Lakehouse가 PostgreSQL Catalog Plane을 구축하면서 Polaris/Nessie와 유사한 카탈로그 거버넌스 영역을 다루므로 본 연구와 직접 관련.

## 기여 후보 정찰 결과

| 이슈 | 제목 | 상태 | 평가 |
|------|------|------|------|
| [#1325](https://github.com/apache/polaris/issues/1325) | Document Polaris with S3/Azure/GCS | 일부 머지(#1435, S3만), maintainer가 다른 storage backend 문서 필요하다고 명시. assignee 없음 | 진행 후보 |
| [#1119](https://github.com/apache/polaris/issues/1119) | curl cookbook | @jbonofre에게 assigned | 회피 |
| [#1323](https://github.com/apache/polaris/issues/1323) | Helm README publish | @MonkeyCanCode 진행 중 (PR #2014) | 회피 |
| [#2675](https://github.com/apache/polaris/issues/2675) | JDBCPersistence multi-schema test | 미정찰 | 후속 정찰 |
| [#996](https://github.com/apache/polaris/issues/996) | case insensitive storage type names | 미정찰 | 후속 정찰 |
| [#418](https://github.com/apache/polaris/issues/418) | PyIceberg ADLS Vended Credentials | 미정찰 | 후속 정찰 |

## 진행 중

| 이슈/PR | 상태 | 메모 |
|---|---|---|
| [#4594](https://github.com/apache/polaris/issues/4594) / [#4877](https://github.com/apache/polaris/pull/4877) InMemoryBufferEventListener MetricsPersistence 제거 | 리뷰 피드백 반영 · 전체 CI 재통과 · 재리뷰 대기 | listener-local fallback 제거 후 `PolarisCallContext` convenience constructor 경로로 정리. follow-up comment 게시 완료. |

## 머지됨

| PR | 머지일 | 메모 |
|---|---|---|
| [#4451](https://github.com/apache/polaris/pull/4451) AWS S3/Azure Blob production configuration docs | 2026-05-27 | 첫 Polaris/Apache org 머지. 기존 작업 폴더: [issue-1325-storage-docs](./issue-1325-storage-docs/) |

## 다음 세션 진입 후보 (정찰 완료 2026-05-14)

| 이슈 | 평가 | 진입 가능성 |
|------|------|---------|
| [#3621](https://github.com/apache/polaris/issues/3621) DEFAULT_LOCATION_OBJECT_STORAGE_PREFIX_ENABLED docs | maintainer @adutra가 ML 논의 우선 + 회의적 | 회피 (방향 미합의) |

현재는 #4877 재리뷰/merge 대기. 이후 #4600/#4802처럼 작고 명확한 후속 후보 재정찰 권장.

## 참고 링크

- [Polaris GitHub](https://github.com/apache/polaris)
- [공식 사이트](https://polaris.apache.org/)
- [Contributing Guide](https://github.com/apache/polaris/blob/main/CONTRIBUTING.md)
- Apache 프로젝트 — ICLA 서명 필요 (첫 PR 머지 직전 안내됨)
- Slack: ASF Slack `#polaris-catalog`

## 개발 환경 메모

- 언어: Java (Quarkus 기반)
- 빌드: Gradle
- 로컬 clone 예정 경로: `~/chang/Git/polaris`
