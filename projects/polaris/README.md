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

- [#1325 — Azure Blob + GCS storage 문서](./issue-1325-storage-docs/)

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
