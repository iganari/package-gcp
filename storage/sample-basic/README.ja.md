# Sample Basic

Google Cloud Storage にイメージをアップロードする基本的なコード

## 準備

+ Repository を clone し、作業ディレクトリに移動します。

```
git clone hogehoge
```

+ 作業用の Docker コンテナを起動します。 ---> :whale:

```
sh docker-build-run.sh
```

## :whale: gcloud のコンフィグの作成

+ gcloud には 設定をローカルに保持する機能があり、ラベルみたいなもので紐付け、管理することが出来ます(WIP)

```
export _setting_name='sample-lifetime'

gcloud config configurations create ${_setting_name}
```

## :whale: 認証

+ Service accounts を使用します
  + https://cloud.google.com/iam/docs/service-accounts?hl=ja
+ 上記を参考に Service account key を発行して、


## :whale: プロジェクトの設定

+ GCP 上で使用する、プロジェクトを先に指定しておきます。

```
export _pj='iganari_test-qr'

gcloud config set project ${_pj}
```

+ region や zone を設定したい場合は以下のコマンドを実行します。
  + この作業はこの作業に置いては必須ではありません。

```
gcloud config set compute/region asia-northeast1
gcloud config set compute/zone asia-northeast1-a
```

+ Terraform の workspace の設定

```
terraform workspace new ${_pj}
terraform workspace select ${_pj}
```

+ + Terraform の workspace の確認

```
terraform workspace show
```

+ gcloud コマンドの設定の確認

```
gcloud config configurations list
```

## Terraform で GCP にデプロイ

+ init
  + 今回は初回実行のみ

```
terraform init
```

+ plan

```
terraform plan
```

+ apply

```
terraform apply
```


## Terraform で リソースの削除

```
terraform destroy
```
