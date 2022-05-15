# Google Cloud Storage (GCS)

## Documents

https://cloud.google.com/storage/docs/


## Sample Code

This Code is What configure Google Cloud Storage using Terraform.

+ [sample-basic](./sample-basic/README.md)
  + Sample of Basic Architecture in Google Cloud Storage.
+ [sample-access-control](./sample-access-control/README.md)


## Storage Legacy Rule について

GCP での権限管理は基本的には IAM と管理 にて行う

GCS 例外的に IAM と管理 以外でも、アクセス権限を操作することが出来る

2 つ方法があり、それぞれ使い方が異なるので注意する

+ [IAM roles for Cloud Storage | Predefined legacy roles](https://cloud.google.com/storage/docs/access-control/iam-roles#legacy-roles)

## 静的ウェブサイトをホストする

WIP

```
公式ドキュメント
https://cloud.google.com/storage/docs/hosting-static-website
```

## memo

```
オブジェクトのキャッシュについて
https://cloud.google.com/storage/docs/caching
```
