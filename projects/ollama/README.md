# Ollama

Trident가 Ollama로 AI 기반 schema 제안, NL2SQL, dataset description 생성. qwen2.5-coder, bge-m3 임베딩 사용.

## 정찰 결과 (2026-05-14)

`good first issue` 3건 모두 본인 환경 매치 약함:

| 이슈 | 회피 이유 |
|------|---------|
| [#12954](https://github.com/ollama/ollama/issues/12954) sidebar animates opening on load | app UI, 본인 영역 외 |
| [#10333](https://github.com/ollama/ollama/issues/10333) CLI image path | 본인 CLI 미사용 |
| [#4072](https://github.com/ollama/ollama/issues/4072) Prevent sleep on Windows | Windows 영역, 본인 Linux |

## 본인 운영 발견 후보

- 본인 commit `36e4604` "enable KV cache q8_0 quantization" — 본인 환경 튜닝
- 본인이 Ollama + RAG + Confidence-RAG 운영 경험 (AI Champion)
- Ollama docs에 "KV cache quantization with bge-m3" 같은 통합 패턴 부재 가능
- 검증 후 docs PR 가능

## 참고

- 공식 사이트: https://ollama.com
- GitHub: https://github.com/ollama/ollama
- 라이선스: MIT
- 빠르게 성장 중

## 본인 사용 패턴

- TwinX `argocd/trident/apps/ollama/`
- KV cache q8_0 quantization
- 300Gi PVC (large models)
- 본인 stats-service가 Ollama REST API 호출 (schema propose, SQL filter)
