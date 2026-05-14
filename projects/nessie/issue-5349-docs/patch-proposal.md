# Patch Proposal — `site/docs/develop/index.md`

대상 파일: `site/docs/develop/index.md`
변경 라인: 4, 24~25

## Before

```markdown
Nessie builds on the recent ecosystem developments around table formats. The rise of
very large metadata and eventually consistent cloud data lakes (S3 specifically) drove
the need for an updated model around metadata management. Where consistent directory
listings in HDFS used to be sufficient, there were many features lacking. This includes
snapshotting, consistency and fast planning. Apache Iceberg was created to help alleviate
those problems.
```

```markdown
...locks and in hdfs by using atomic file swap operations. These operations don't exist in eventually consistent cloud
object stores, necessitating a Hive metastore for cloud data lakes. The Nessie system is designed to store the
root metadata pointer and perform atomic updates to this pointer, obviating the need for a Hive metastore.
```

## After

```markdown
Nessie builds on the recent ecosystem developments around table formats. The rise of
very large metadata and cloud data lakes (S3 specifically) drove
the need for an updated model around metadata management. Where consistent directory
listings in HDFS used to be sufficient, there were many features lacking. This includes
snapshotting, consistency and fast planning. Apache Iceberg was created to help alleviate
those problems.
```

```markdown
...locks and in hdfs by using atomic file swap operations. While modern cloud object stores
(S3 since December 2020, GCS and Azure Blob since launch) provide strong read-after-write
consistency, they still lack atomic multi-object swap operations, necessitating a Hive
metastore for cloud data lakes. The Nessie system is designed to store the
root metadata pointer and perform atomic updates to this pointer, obviating the need for a Hive metastore.
```

## Diff (unified)

```diff
--- a/site/docs/develop/index.md
+++ b/site/docs/develop/index.md
@@ -1,8 +1,8 @@
 # Architecture

 Nessie builds on the recent ecosystem developments around table formats. The rise of
-very large metadata and eventually consistent cloud data lakes (S3 specifically) drove
+very large metadata and cloud data lakes (S3 specifically) drove
 the need for an updated model around metadata management. Where consistent directory
 listings in HDFS used to be sufficient, there were many features lacking. This includes
 snapshotting, consistency and fast planning. Apache Iceberg was created to help alleviate
 those problems.
@@ -21,8 +21,10 @@ Iceberg currently relies on the Hive metastore or hdfs to perform
 this role. The requirements for this root pointer store is it must hold (at least) information about the location of the
 current up-to-date metadata file, and it must be able to update this location atomically. In Hive this is accomplished by
-locks and in hdfs by using atomic file swap operations. These operations don't exist in eventually consistent cloud
-object stores, necessitating a Hive metastore for cloud data lakes. The Nessie system is designed to store the
+locks and in hdfs by using atomic file swap operations. While modern cloud object stores
+(S3 since December 2020, GCS and Azure Blob since launch) provide strong read-after-write
+consistency, they still lack atomic multi-object swap operations, necessitating a Hive
+metastore for cloud data lakes. The Nessie system is designed to store the
 root metadata pointer and perform atomic updates to this pointer, obviating the need for a Hive metastore.
```

## 변경 의도 요약

1. **line 4**: "eventually consistent" 형용사만 제거.
   "cloud data lakes (S3 specifically) drove the need..."는 문장 흐름상 그대로 유지.
2. **line 24~25**: 핵심 수정.
   - 사실: S3는 2020-12부터 strong consistency
   - 그러나 Nessie/Hive metastore가 여전히 필요한 이유는 **atomicity**의 부재
   - 두 개념을 명시적으로 구분해 문서의 논리 흐름 유지

## 결과적으로 보존되는 것

- Nessie 존재 이유 (atomic 갱신 보장)
- 글의 historical 흐름 (HDFS → cloud → Iceberg → Nessie)
- "왜 Hive metastore 또는 Nessie가 필요한가" 라는 핵심 메시지

## 변경되는 것

- S3가 eventually consistent라는 잘못된 진술 제거
- consistency와 atomicity의 구분 명시
