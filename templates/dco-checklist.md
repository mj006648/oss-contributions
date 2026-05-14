# DCO Sign-off Checklist

DCO(Developer Certificate of Origin)는 커밋 메시지 끝에 한 줄을 추가해 "이 코드는 내가 합법적으로 기여할 권리가 있다"를 선언하는 방식이다. Nessie, ArgoCD, Linux Kernel 등 다수 프로젝트가 채택.

## 1회 설정

```bash
# git 글로벌 사용자명/이메일 (GitHub 계정과 동일 이메일 사용 권장)
git config --global user.name "ChangHyeon Im"
git config --global user.email "uckdekf@gmail.com"
```

## 매 커밋

```bash
git commit -s -m "fix: resolve STDOUT redirect issue in CLI"
```

`-s` 플래그가 다음 줄을 자동 추가한다:

```
Signed-off-by: ChangHyeon Im <uckdekf@gmail.com>
```

## 까먹었을 때 (마지막 커밋만 sign-off 추가)

```bash
git commit --amend -s --no-edit
git push --force-with-lease
```

## 여러 커밋 한꺼번에 sign-off

```bash
# main 분기 이후 모든 커밋
git rebase --signoff main
git push --force-with-lease
```

## 검증

```bash
git log -1 --format=%B
# 마지막 줄에 Signed-off-by: ... 가 보여야 함
```

## 자주 막히는 부분

- GitHub 이메일과 커밋 이메일이 다르면 GitHub이 커밋을 본인 것으로 인식 못 함
- DCO 봇이 PR에서 sign-off 누락을 자동 감지해 알려줌
- 회사/학교 이메일과 개인 GitHub 이메일이 다르면 커밋 이메일을 GitHub Settings → Emails에 등록해야 함
