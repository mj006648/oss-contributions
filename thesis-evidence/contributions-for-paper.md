# Thesis Evidence — Upstream Contributions

석사 논문 본문 및 부록에서 인용할 수 있는 upstream 기여 활동을 정리한다.

## 활용 방향

- 본문 5장(구현 및 평가): "본 연구 수행 중 발견한 upstream 개선점을 N건 기여하였다" 형태로 짧게 언급
- 부록: PR/이슈 목록 표 (프로젝트, 번호, 제목, 상태, URL)
- CV(`6_curriculum vitae.tex`): Open Source Contributions 섹션

## 기여 목록

| 프로젝트 | 이슈/PR | 제목 | 상태 | 머지일 | URL |
|---------|---------|------|------|--------|-----|
| Nessie  | #10865  | CLI STDOUT redirect 버그 | 의도 코멘트 게시 | - | https://github.com/projectnessie/nessie/issues/10865 |
| Nessie  | #5349   | Cloud Object Storage 일관성 문서 | 의도 코멘트 게시 | - | https://github.com/projectnessie/nessie/issues/5349 |
| ArgoCD  | #18198  | `--request-timeout` docs/code 불일치 | 의도 코멘트 게시 | - | https://github.com/argoproj/argo-cd/issues/18198 |
| Polaris | #1325   | Azure/GCS storage 문서 | 의도 코멘트 게시 | - | https://github.com/apache/polaris/issues/1325 |

## 논문 본문 예시 문구 (초안)

> 본 연구 수행 과정에서 발견된 Nessie CLI의 STDOUT redirect 동작 문제를 upstream에 보고하고 수정 PR(#10865)을 기여하였다. 또한 객체 스토리지 일관성 모델 관련 문서가 AWS S3의 strong consistency 정책(2020년 12월 이후)을 반영하지 않은 부분을 발견하여 문서 갱신 PR(#5349)을 제출하였다.

## CV 항목 예시 (초안)

```
Open Source Contributions
  - Project Nessie (https://github.com/projectnessie/nessie)
      * PR #XXXXX: Fix CLI STDOUT redirect (merged YYYY-MM)
      * PR #XXXXX: Update cloud object storage consistency docs (merged YYYY-MM)
```
