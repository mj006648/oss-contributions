# PR Description Template

```markdown
## Summary

(한두 줄로 무엇을 바꿨고 왜 바꿨는지)

## Related Issue

Fixes #<issue-number>
(또는 `Refs #<issue-number>` — 자동 close가 적절하지 않을 때)

## Changes

- (변경 1)
- (변경 2)
- (변경 3)

## How to Test

```bash
# 재현 또는 검증 명령
```

기대 결과:
(어떤 출력/동작이 나와야 하는지)

## Screenshots / Logs

(해당 시)

## Checklist

- [ ] Tests added / updated
- [ ] Documentation updated
- [ ] DCO sign-off (`git commit -s`)
- [ ] CI passes locally
- [ ] No unrelated changes
```

## 작성 팁

- 첫 줄(Summary)이 가장 중요. 리뷰어가 이거 한 줄만 읽고도 의도가 파악되어야 함.
- "Why"가 "What"보다 우선. 무엇을 바꿨는지는 diff에 다 있다.
- 50줄 이하 PR이 이상적. 그 이상이면 분할 고려.
- 영어로 작성. 간단한 문법이라도 문제없음.
