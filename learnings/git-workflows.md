# Git Workflows for OSS Contribution

## 표준 PR 워크플로우

```bash
# 1. upstream repo fork (GitHub 웹에서)
# 2. fork한 본인 repo를 clone
git clone https://github.com/mj006648/<repo>.git
cd <repo>

# 3. upstream remote 추가
git remote add upstream https://github.com/<org>/<repo>.git
git remote -v

# 4. 작업 브랜치 생성
git checkout -b fix/issue-10865-stdout-redirect

# 5. 작업 후 커밋 (DCO sign-off)
git add <changed-files>
git commit -s -m "fix(cli): redirect STDOUT correctly when piped"

# 6. 본인 fork로 push
git push origin fix/issue-10865-stdout-redirect

# 7. GitHub 웹에서 PR 생성 (upstream/main 대상)
```

## upstream 최신 변경 가져오기 (수시)

```bash
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

## 작업 브랜치를 최신 main에 rebase

```bash
git checkout fix/issue-10865-stdout-redirect
git fetch upstream
git rebase upstream/main
# 충돌 해결 후
git push --force-with-lease origin fix/issue-10865-stdout-redirect
```

## 리뷰 피드백 반영

```bash
# 코드 수정 후
git add <files>
git commit -s -m "address review: rename variable for clarity"
git push origin fix/issue-10865-stdout-redirect
# PR에 자동 반영됨
```

## 커밋 squash (머지 전 정리 요청받았을 때)

```bash
git rebase -i HEAD~3   # 최근 3개 커밋 정리
# pick 첫 줄 + squash 나머지
git push --force-with-lease
```

## 자주 쓰는 명령

```bash
git log --oneline -10              # 최근 10개 커밋
git diff upstream/main..HEAD       # PR에 포함될 변경
git status                         # 현재 상태
git stash                          # 작업 임시 보관
git stash pop                      # 보관한 작업 복원
```

## 주의

- `--force-with-lease`는 본인 브랜치에만. main/master에 절대 force push 금지.
- `git push origin main`은 본인 fork의 main으로만. upstream으로 push 시도되면 권한 거부됨 (정상).
- DCO 빠뜨리면 봇이 PR에서 빨간 X 표시 → 위 sign-off 추가 후 force push로 정정.
