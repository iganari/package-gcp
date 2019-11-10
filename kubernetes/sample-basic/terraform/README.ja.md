# basic sample of GKE

WIP
## これは何?

Google Cloud Storage にアップロードしたオブジェクトに権限を付与して、閲覧・削除が出来るようにします。

## 準備

+ GCP のアカウントを作成します。
  + ここは他の記事におまかせします。

+ Repository を clone し、作業ディレクトリに移動します。

```
git clone https://github.com/iganari/package-gcp.git
```

+ 作業用の Docker コンテナを起動します。 ---> :whale:
  + 以降は :whale: が付いているコマンドはこの Docker コンテナの中で実行しています。

```
cd package-gcp/storage/sample-access-control
sh docker-build-run.sh
```

## :whale: gcloud のコンフィグの作成

+ gcloud には 設定をローカルに保持する機能があり、ラベルみたいなもので紐付け、管理することが出来ます(WIP)

```
export _setting_name='sample-lifecycle'

gcloud config configurations create ${_setting_name}
gcloud config configurations list
```

## :whale: gcloud コマンドによる認証

+ ブラウザを介して、認証を行います。

```
gcloud auth application-default login
```

## :whale: プロジェクトの設定

+ GCP 上で使用する、プロジェクトを先に指定しておきます。

```
export _pj='iganari_test-qr'

gcloud config set project ${_pj}
```

+ Terraform の workspace の設定
  + Terraform には workspace という機能があり、それを用います。

```
terraform workspace new ${_pj}
terraform workspace select ${_pj}
```

+ Terraform の workspace の確認

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
