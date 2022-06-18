# Cloud Build

## 概要

Cloud Build は、Google Cloud 上でビルドを実行するサービスです。

Cloud Build は、さまざまなリポジトリやクラウド ストレージ スペースからソースコードをインポートし、仕様に合わせてビルドを実行し、Docker コンテナや Java アーカイブなどのアーティファクトを生成できます。

```
Overview of Cloud Build
https://cloud.google.com/build/docs/overview
```

## サンプル

### [Basic Sample](./basic-sample)

Cloud Build Trigger の基礎的なサンプル

### [ClamAV](./clamav)

オープンソースのセキュリティソフトのアンチウイルスエンジン

### [Cloud Scheduler](./cloudscheduler)

WIP

### [Notifications](./notifications)

WIP

### [Parallel Step](./parallel-step)

WIP

### [Pluto by Fairwinds](./pluto)

WIP

### [Pub/Sub](./pubsub)

WIP

### [Python on Cloud Build](./python)

WIP

### [Servcie Account について](./service-account)

WIP

### [Terraform](./terraform/)

Terraform にまつわるサンプル

+ [Terraform のバージョンチェック](./terraform/README.md#terraform-のバージョンチェック)

### [Trivy](./trivy)

コンテナイメージ内の OS やライブラリやモジュールなどの脆弱性のチェック

### [GKE](../kubernetes/builds)

GKE Cluster 上にデプロイする


## 参考ドキュメント

```
Cloud Build のサンプル
https://console.cloud.google.com/cloud-build
```
```
変数値の置換
https://cloud.google.com/build/docs/configuring-builds/substitute-variable-values
```
```
ビルド構成ファイルのスキーマ
https://cloud.google.com/build/docs/build-config-file-schema
```
```
Cloud builders
https://cloud.google.com/build/docs/cloud-builders
```
```
github.com/GoogleCloudPlatform/cloud-builders
https://github.com/GoogleCloudPlatform/cloud-builders/tree/master/gcloud
```
```
Configuring the order of build steps
https://cloud.google.com/build/docs/configuring-builds/configure-build-step-order
```
