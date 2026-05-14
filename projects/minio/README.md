# MinIO

본인 Trident는 사실 **Ceph RGW S3 호환** 사용. MinIO 클라이언트 라이브러리(`minio==7.2.15`)는 Stats Service에서 S3 호출용.

## 정찰 결과 (2026-05-14)

`good first issue` 직접 검색 결과 빈약 — gh search 정확도 낮음.

## 본인 운영 발견 후보

- 본인 commit `c9c6f54` "use RGW admin credentials for all-bucket S3 access"
- Trino + Ceph RGW + cross-bucket 접근 시 admin credential 필요한 패턴
- MinIO docs에 명시 부재 가능 (다만 Ceph RGW 영역이라 부적합)

## 참고

- 공식 사이트: https://min.io
- GitHub: https://github.com/minio/minio
- 라이선스: AGPL v3 (commercial license 옵션)
- 본인 Ceph RGW 사용, MinIO는 client lib만

## 본인 사용 패턴

- `stats-service/requirements.txt`에 `minio==7.2.15`
- Bucket listing, presigned URL 생성
- Ceph RGW endpoint 호출
