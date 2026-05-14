# PR Draft — Nessie #5349

## PR Title

```
docs: update outdated eventual consistency wording for cloud object stores
```

## PR Body

```markdown
## Summary

Refreshes `site/docs/develop/index.md` so it no longer describes modern
cloud object stores as eventually consistent. AWS S3 has provided strong
read-after-write consistency since December 2020, and GCS / Azure Blob
have been strongly consistent since launch.

The technical motivation for Nessie is preserved: cloud object stores
still lack atomic multi-object swap / rename, which is the real reason a
Hive-metastore-like component (or Nessie) is needed. Only the
consistency wording is corrected.

## Related Issue

Closes #5349

## Changes

- `site/docs/develop/index.md`
  - line 4: drop "eventually consistent" qualifier on cloud data lakes
  - line 24: replace "eventually consistent cloud object stores" with a
    statement that distinguishes consistency (now strong) from atomic
    multi-object operations (still missing)

No other docs needed updating — a wider scan of `site/` showed that all
other uses of "consistent" / "consistency" describe Nessie's own
guarantees and are accurate.

## How to Verify

1. Read the rendered `develop/Architecture` page locally:
   ```bash
   pip install -r site/requirements.txt
   mkdocs serve -f site/mkdocs.yml
   ```
2. Confirm the Architecture section no longer claims S3 is eventually
   consistent, but still explains why Nessie (rather than raw S3) is
   needed.

## References

- AWS S3 strong consistency announcement (Dec 2020):
  https://aws.amazon.com/s3/consistency/
- GCS consistency model:
  https://cloud.google.com/storage/docs/consistency
- Azure Blob storage consistency:
  https://learn.microsoft.com/azure/storage/blobs/concurrency

## Checklist

- [x] DCO sign-off
- [x] No unrelated changes
- [x] Only docs touched; no build / test impact
```

## 작성 메모

- 제목: conventional commit 스타일 (`docs:` 접두사) — Nessie도 이 스타일 사용
- "Closes #5349" 키워드로 머지 시 이슈 자동 종료
- "왜 이 수정이 안전한가"(atomicity 보존) 명시해서 maintainer가 의심 안 하게 함
- 외부 레퍼런스 3개로 사실관계 증명
- 다른 문서 안 건드린 이유까지 미리 적어 "범위가 작은가?"라는 질문 차단
