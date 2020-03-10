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

## configurations

+ gcloud コマンドを使う際の設定
+ 環境ごとに設定を分けて、それを切り替えて使うことが可能
+ どんな名前でもいいが、GCP プロジェクトと紐付けると見分けやすい


+ config の作成

```
gcloud config configurations create ${Your Project Name}
```

+ config リストの確認

```
gcloud config configurations list
```

```
### ex
_my_project_name='iganari-test-2020'

gcloud config configurations create ${_my_project_name}
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a
gcloud config set project ${_my_project_name}

# gcloud config configurations list
NAME                 IS_ACTIVE  ACCOUNT                     PROJECT              DEFAULT_ZONE       DEFAULT_REGION
iganari-test-2020    True       hogehoge@example.com        iganari-test-2020    us-central1-a      us-central1
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
