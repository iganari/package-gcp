# Cloud Run

## 概要

Google のスケーラブルなインフラストラクチャ上でコンテナを直接実行できるマネージド コンピューティング プラットフォーム


```
Cloud Run とは
https://cloud.google.com/run/docs/overview/what-is-cloud-run
```

[![](https://img.youtube.com/vi/1t94tdyojs0/0.jpg)](https://www.youtube.com/watch?v=1t94tdyojs0)

```
## アーキテクチャセンターで「 run 」と検索
https://cloud.google.com/architecture#/?q=run
```

## サンプル

+ [基本的な使い方](./_basic/)
  + Cloud Run の基本的な使い方を見ていく

## 周辺の機能など

+ [ID トークンによる簡易認証](./feature-authorization-developer/)
  + Google Account の ID トークンを使った Cloud Run の簡易認証
+ <WIP> [Cloud Build to Cloud Run](./feature-builds/)
  + Cloud Build を使った Cloud Run のデプロイのサンプル
+ <WIP> [カスタムドメインのマッピング](./feature-mapping-custom-domains/)
  + Cloud Run が提供するデフォルトのアドレスではなく、独自のドメイン(カスタムドメイン)を設定したい
+ <WIP> [Cloud Storage と接続する](./feature-network-filesystems-fuse/)
  + GCS をネットワークファイルシステムとしてマウントすることが出来る
+ <WIP> [Serverless VPC Access](./feature-serverless-vpc-access/)
  + GCP 内で内部通信したい場合(Memorystore など)に繋ぐ際に必要になる
+ [Setting up a load balancer with Cloud Run](./feature-under-load-balancer/)
  + Google Cloud Load Balancing( GCLB ) の下に Cloud run を設置する
+ [WIP] 外部 IP アドレスが付いていない GCE インスタンスから Cloud Run にアクセスする
  + WIP

## ハンズオン

+ [Cloud Run 上の phpMyAdmin を経由して Cloud SQL にアクセスする環境を構築するハンズオン](./handson-run-phpmyadmin-sql/README.md)

## 注意点

### 1. アドレスについて

起動しているコンテナは `0.0.0.0` で受けて実行できるようにしないといけない。変更不可

https://cloud.google.com/run/docs/reference/container-contract#port

### 2. ポートについて

起動しているコンテナは `8080 ポート` で受けて実行できるようにしないといけない。これは変更可能

```
デフォルトの Port 変更する
gcloud run services update {_run_service_name} --port {_container_port} --region ${_region} --project ${_gcp_pj_id}
```
```
https://cloud.google.com/run/docs/configuring/containers?hl=en#configure-port
```

### 3. リクエストのタイムアウト

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

※ ただし、 Cloud Run の最小インスタンスを設定した場合はそちらが優先される

### 4. 常時起動させておきたい

最小インスタンス数を設定することでウォーム状態を維持し、いつでもリクエストを処理できるコンテナインスタンスを維持する

:fire: ただし、課金が常に発生する

```
最小インスタンス数（サービス）
https://cloud.google.com/run/docs/configuring/min-instances
```

### 5. Cloud SQL に接続する時の情報

+ Cloud SQL のパブリックIPアドレスに接続する場合
  + 自動的に Cloud SQL Auth Proxy 経由で繋げる  
+ Cloud SQL の内部IPアドレスに接続する場合
  + Serverless VPC Access を事前に準備をする必要があるが、 Cloud SQL Auth Proxy は使わずに繋げる
+ instance name の場合はどちらになるか?
  + 要確認
  
https://cloud.google.com/sql/docs/postgres/connect-instance-cloud-run?hl=ja#deploy_sample_app_to

  
## 6. インスタンスあたりの最大同時リクエスト数
  
https://cloud.google.com/run/docs/about-concurrency
  
![](https://cloud.google.com/run/docs/images/concurrency-diagram.svg)

## 参考 URL

+ 公式ドキュメント or 公式ブログ
  + [60 を超える Google Cloud ソースのイベントで Cloud Run をトリガーする](https://cloud.google.com/blog/ja/products/serverless/build-event-driven-applications-in-cloud-run)
  + [新しい CPU 割り当てコントロールにより Cloud Run 上でさらに多様なワークロードを実行](https://cloud.google.com/blog/ja/products/serverless/cloud-run-gets-always-on-cpu-allocation)
  + [Cloud Run を最大限使いこなすには](https://lp.cloudplatformonline.com/rs/808-GJW-314/images/App_Modernization_OnAir_q1_0217_Session.pdf)
+ 他の記事
  + TBD
