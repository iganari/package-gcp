# Cloud Storage

## 概要

```
公式ドキュメント
https://cloud.google.com/storage/docs/
```

## gsutil

[gsutil](./_gsutil/)

## サンプルコード

This Code is What configure Google Cloud Storage using Terraform.

+ [Hosting Static Website Single](./hosting-static-website-single)
    + 単一の静的ウェブサイトのホスティング
+ [Hosting Static Website Multi](./hosting-static-website-multi)
    + 複数の静的ウェブサイトのホスティング
+ [sample-basic](./sample-basic/README.md)
  + Sample of Basic Architecture in Google Cloud Storage.
+ [sample-access-control](./sample-access-control/README.md)
  + Terraform を使って、オブジェクトに権限を付与して、閲覧・削除が出来る条件を付与します。

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

## Cloud Run での Cloud Storage FUSE の使用

:point_right: [Cloud Run での Cloud Storage FUSE の使用](../run/network-filesystems-fuse/)


## Lifecycle について

```
Object Lifecycle Management
https://cloud.google.com/storage/docs/lifecycle
```

## metadata

+ [Get bucket size and metadata](https://cloud.google.com/storage/docs/getting-bucket-size-and-metadata)

## memo

```
オブジェクトのキャッシュについて
https://cloud.google.com/storage/docs/caching
https://cloud.google.com/storage/docs/metadata#caching_data
```
