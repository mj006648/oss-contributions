# NVIDIA

본인 Trident 클러스터 l40s 노드 GPU 8장 사용. Trident-Twin이 Omniverse 활용. 직접 연관성 높음.

## 정찰 결과 (2026-05-14)

### NVIDIA/k8s-device-plugin
- `good first issue` 라벨: **0건**
- `help wanted` 라벨: 0건
- `documentation` 라벨: 0건
- 진입 거의 불가능 (라벨 정책 없음)

### NVIDIA/gpu-operator
- `good first issue` 라벨: 1건 → **회피** (#1677은 Dependabot 자동 PR, 사람 이슈 X)
- `help wanted` 일부 있으나 사실상 모두 maintainer 작업

### 후보 sub-project
- NVIDIA/aistore (data loading + S3)
- NVIDIA/dali (data loading)
- NVIDIA/Megatron-LM (LLM training)

모두 별도 정찰 필요.

## 핵심 발견

**NVIDIA는 외부 contributor 친화 정도 낮음**: 라벨 체계 미정비 + 자동 PR(Dependabot) 위주.

## 진입 전략

직접 진입 어려움. 우회:
1. **본인 Trident l40s 노드 운영 중 발견한 k8s-device-plugin/gpu-operator 버그**를 새 이슈로 등록 (메모리 `project_l40s_netplan_src.md` 참고)
2. Isaac Sim / Omniverse 운영 중 발견한 문서 부족
3. NVIDIA NIM 또는 cuda-related Helm chart 버그

## 참고

- 라이선스: 다양 (Apache 2.0, BSD-3, NVIDIA Proprietary)
- CLA: 일부 repo NVIDIA-CLA 필요
- Slack: 없음, GitHub Discussions
