# Apache Iceberg (Java)

[Apache Iceberg](https://github.com/apache/iceberg)는 본 연구의 Lakehouse Core 그 자체. Snapshot, schema evolution, partition evolution, manifest 구조가 Trident 전체 설계의 기반.

## 기여 후보 정찰 결과

| 이슈 | 제목 | 상태 | 평가 |
|------|------|------|------|
| [#14925](https://github.com/apache/iceberg/issues/14925) | spec: clarify partition value when writing data files | assignee 없음, maintainer가 추가 설명 요청 | 신중 진행 (spec 변경) |
| [#15916](https://github.com/apache/iceberg/issues/15916) | Spark branch + WAP docs | PR #15917 진행 중 | 회피 |
| [#14227](https://github.com/apache/iceberg/issues/14227) | REST fixture INFO log flood | PR #14260 리뷰 대기 | 회피 |
| [#15852](https://github.com/apache/iceberg/issues/15852) | ADLS credentials scheduled refresh | 미정찰 | 후속 정찰 (Azure 미사용) |
| [#15556](https://github.com/apache/iceberg/issues/15556) | Update Benchmarks doc | 미정찰 | 후속 정찰 |
| [#15347](https://github.com/apache/iceberg/issues/15347) | Disabling statistics across columns | 미정찰 | 후속 정찰 |

## 보류 후보

- [#14925 — spec partition value 명문화](./issue-14925-partition-value-spec/) — Apache spec 변경이라 PMC 리뷰 필요, 첫 기여로는 부담

## 참고 링크

- [Iceberg GitHub](https://github.com/apache/iceberg)
- [Contributing Guide](https://iceberg.apache.org/contribute/)
- Apache ICLA 서명 필요 (첫 PR 전)
- Dev 메일링리스트: dev@iceberg.apache.org
- Slack: ASF Slack `#iceberg`

## 개발 환경 메모

- 언어: Java
- 빌드: Gradle
- 로컬 clone 예정 경로: `~/chang/Git/iceberg`
- 대형 프로젝트(코어 + Spark + Flink + Hive 등 멀티 모듈) — 클론 용량과 빌드 시간 큼
