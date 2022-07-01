# Cloud Run

## 概要

Google のスケーラブルなインフラストラクチャ上でコンテナを直接実行できるマネージド コンピューティング プラットフォーム


```
Cloud Run とは
https://cloud.google.com/run/docs/overview/what-is-cloud-run
```

[![](https://img.youtube.com/vi/1t94tdyojs0/0.jpg)](https://www.youtube.com/watch?v=1t94tdyojs0)

## 基本的な動作


## サンプル

+ [Cloud Build to Cloud Run](./builds)
  + Cloud Build を使った Cloud Run のデプロイのサンプル



## 注意点

### アドレスについて

起動しているコンテナは `0.0.0.0` で受けて実行できるようにしないといけない。変更不可

https://cloud.google.com/run/docs/reference/container-contract#port

### ポートについて

起動しているコンテナは `8080 ポート` で受けて実行できるようにしないといけない。これは変更可能

```
デフォルトの Port 変更する
gcloud run services update {_run_service_name} --port {_container_port} --region ${_region} --project ${_gcp_pj_id}
```
```
https://cloud.google.com/run/docs/configuring/containers?hl=en#configure-port
```

### リクエストのタイムアウト

デフォルトで 5 分、 最大 60 分まで延長可能


```
### 既存のサービスの設定変更
gcloud run services update [SERVICE] --timeout=[TIMEOUT]

OR

### Cloud Run のデプロイ時に設定
gcloud run deploy --image IMAGE_URL --timeout=[TIMEOUT]
```


```
リクエスト タイムアウトの設定（サービス）
https://cloud.google.com/run/docs/configuring/request-timeout
```


## ユースケース

### GCP 内で内部通信したい場合

+ MemoryStore など

[Serverless VPC Access](../networking/connectors)

### 外部 IP アドレスが付いていない GCE インスタンスから Cloud Run にアクセスする

TBD

## 参考 URL

+ [新しい CPU 割り当てコントロールにより Cloud Run 上でさらに多様なワークロードを実行](https://cloud.google.com/blog/ja/products/serverless/cloud-run-gets-always-on-cpu-allocation)

## 簡易的な ID トークン 認証

[Authenticating developers](./authorization_developer/)

## Cloud Run で永続的な Disk に書き込みしたい

+ Cloud Run で Cloud Storage FUSE を使うことで、FileStote と繋げることが出来る

```
チュートリアル: Cloud Run での Cloud Storage FUSE の使用
https://cloud.google.com/run/docs/tutorials/network-filesystems-fuse
```
