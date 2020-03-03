# gcloud の覚書

## Auth

[auth](https://cloud.google.com/sdk/gcloud/reference/auth/)

認証について

+ gcloud auth コマンドにて GCP との認証を行えます。
+ Web ブラウザが必要になるので、その環境を用意して下さい。

+ そのターミナル上で GCP を操作する場合
  + ブラウザの認証が必要

```
gcloud auth login
```
 
+ SDK や Terraform のようなプログラムを介して、 GCP を操作する場合
  + ブラウザの認証が必要

```
gcloud auth application-default login
```

+ Service Account に紐づくキーを用いて認証を行う場合
  + ブラウザの認証が `不` 必要

```
gcloud auth activate-service-account \
    --key-file=service-account.json
```

## めも

+ VPC ネットワーク作成

```
### めんどくさい人向け(非推奨)

gcloud compute networks create auto-network --subnet-mode auto
```

```
### 日本 に限定して VPC ネットワークの作成

gcloud compute networks create custom-network1 --subnet-mode custom

gcloud compute networks subnets create subnets-us-central-192 --network custom-network1 --region us-central1 --range 192.168.1.0/24
gcloud compute networks subnets create subnets-europe-west-192 --network custom-network1 --region europe-west1 --range 192.168.5.0/24
gcloud compute networks subnets create subnets-asia-east-192 --network custom-network1 --region asia-east1 --range 192.168.7.0/24
```
