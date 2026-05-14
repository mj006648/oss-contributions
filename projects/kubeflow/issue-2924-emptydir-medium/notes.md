# Kubeflow spark-operator #2924 — EmptyDir medium field not forwarded

- 원본 이슈: https://github.com/kubeflow/spark-operator/issues/2924
- 등록일: 2026-04-27
- 라벨: kind/bug
- assignee: 없음
- 상태: 의도 코멘트 게시 (2026-05-14)

## 이슈 본문 요약

SparkApplication CR에서 `spark-local-dir` emptyDir에 `medium: Memory` 설정 시 sizeLimit만 forward되고 medium 필드가 누락됨.

영향:
- spark.local.dir이 tmpfs(메모리 기반)가 아닌 디스크에 쓰여 shuffle 성능 저하
- 본인 Trident의 trident_structurize.py / trident_index.py가 spark.local.dir에 의존 → 같은 패턴 영향 가능

## 코드 위치 (보고자가 명시)

`internal/controller/sparkapplication/submission.go:536`

```
https://github.com/kubeflow/spark-operator/blob/5691a545596b4af013a2a6d5a683bf71f35b7b90/internal/controller/sparkapplication/submission.go#L536
```

## 작업 계획

1. 로컬 또는 본인 TwinX 클러스터에서 재현
   - SparkApplication에 emptyDir.medium=Memory 설정
   - 렌더링된 driver/executor pod spec에서 medium 누락 확인
2. submission.go 수정 — emptyDir volume 변환 시 medium 필드 복사
3. unit test 추가
   - medium=Memory + sizeLimit=1Gi 케이스
   - medium 없음 (default) 케이스 (regression 방지)
4. Draft PR 제출

## 환경

- Kubernetes Version: 1.35.2 (보고자 환경, 본인은 1.31~1.33)
- Spark Operator Version: 2.3.0 (master에서도 미해결)
- Apache Spark Version: 3.5.6 (본인 사용 3.5.2와 유사)

## 작업 체크리스트

- [x] 이슈 본문 정독
- [x] 코드 위치 확인 (submission.go:536)
- [x] 의도 코멘트 게시 (https://github.com/kubeflow/spark-operator/issues/2924#issuecomment-4448797914)
- [ ] spark-operator repo fork & clone
- [ ] Go toolchain 환경 셋업
- [ ] 로컬 또는 TwinX에서 bug 재현
- [ ] submission.go 수정
- [ ] unit test 작성
- [ ] DCO sign-off 커밋
- [ ] Draft PR 제출

## 참고

- 본인 Trident `argocd/trident-spark/` 운영 = 실사용자 검증 강점
- 본인 stats-service `routers/spark.py`의 `_spark_app_body()` 함수에서 `spark.local.dir: /var/data/spark` 사용 (emptyDir volume)
- DCO sign-off (`git commit -s`)
