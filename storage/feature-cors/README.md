# Cross-Origin Resource Sharing (CORS) について

## 概要

Web ブラウザのセキュリティ機能 (同一生成元ポリシー) を緩和し、異なるドメイン (オリジン) 間でリソース (データ、APIなど) へのアクセスを許可するための仕組み

GCS Bucket 単位で CORS の設定をすることが出来る

## 設定方法

※ 2025/12 現在、 GUI からは設定できなく、 API 経由で設定する必要がある

- CLI (gcloud) ---> https://docs.cloud.google.com/sdk/gcloud/reference/storage/buckets/update#--cors-file
- Terraform ---> https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket

## 確認方法

※ 2025/12 現在、 GUI からは設定できなく、 API 経由で設定する必要がある

```
gcloud storage buckets describe gs://hogehoge-fugafuga-buckets
```
```
### 例

$ gcloud storage buckets describe gs://hogehoge-fugafuga-buckets
cors_config:
- maxAgeSeconds: 3600
  method:
  - GET
  - HEAD
  - PUT
  - POST
  - OPTIONS
  origin:
  - http://localhost:3000
  responseHeader:
  - Content-Type
  - Content-Length
  - Content-MD5
  - x-goog-resumable
creation_time: 2025-08-06T09:11:37+0000
default_storage_class: STANDARD
generation: 1754471496935329102
labels:
  goog-terraform-provisioned: 'true'
location: ASIA-NORTHEAST1
location_type: region
metageneration: 27
name: hogehoge-fugafuga-buckets
public_access_prevention: inherited
soft_delete_policy:
  retentionDurationSeconds: '0'
storage_url: gs://hogehoge-fugafuga-buckets/
uniform_bucket_level_access: true
update_time: 2025-12-24T05:15:11+0000
versioning_enabled: false
```
