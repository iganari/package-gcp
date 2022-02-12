# Cloud Run

## 概要

WIP

## 基本的な動作

WIP

### API の有効化

```
gcloud beta services enable run.googleapis.com --project { Your GCP Project ID}
```
```
gcloud beta services list --enabled --filter='run.googleapis.com' --project { Your GCP Project ID}
```

## サンプル

+ [Cloud Build to Cloud Run](./builds)
  + Cloud Build を使った Cloud Run のデプロイのサンプル

## 必要な Role

+ デプロイ時
  + Cloud Run Admin ( `roles/run.admin` )
  + Service Account User ( `roles/iam.serviceAccountUser` )

```
デプロイ時に必要な role
https://cloud.google.com/run/docs/reference/iam/roles#additional-configuration
```

## 注意点

### アドレスについて

起動しているコンテナは `0.0.0.0` で受けて実行できるようにしないといけない。変更不可

https://cloud.google.com/run/docs/reference/container-contract#port

### ポートについて

起動しているコンテナは `8080 ポート` で受けて実行できるようにしないといけない。これは変更可能

```
デフォルトの Port 変更する
gcloud run services update {_run_service_name} --port {_container_port} --region ${_region} --project ${_gcp_pj_id}


https://cloud.google.com/run/docs/configuring/containers?hl=en#configure-port
```

### 内部通信する場合

[Serverless VPC Access](../networking/connectors)

## 参考 URL

+ [新しい CPU 割り当てコントロールにより Cloud Run 上でさらに多様なワークロードを実行](https://cloud.google.com/blog/ja/products/serverless/cloud-run-gets-always-on-cpu-allocation)

## Bearer で認証する

[](./authorization_bearer/)