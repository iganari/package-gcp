# Sample Count

## これは何?

Google Cloud Storage にイメージをアップロードする基本的なコードです。

## 準備

+ GCP のアカウントを作成します。
  + ここは他の記事におまかせします。

+ Repository を clone し、作業ディレクトリに移動します。
  + 最新のソースコードのみを clone するオプションをつけています。

```
git clone --branch master --depth 1 https://github.com/iganari/package-gcp.git
```

+ 作業用の Docker コンテナを起動します。 ---> :whale:
  + 以降は :whale: が付いているコマンドはこの Docker コンテナの中で実行しています。

```
sh docker-build-run.sh
```

## :whale: gcloud のコンフィグの作成

+ gcloud には 設定をローカルに保持する機能があり、ラベルみたいなもので紐付け、管理することが出来ます(WIP)

```
export _setting_name='sample-count'

gcloud config configurations create ${_setting_name}
```

## :whale: 認証

+ gcluud コマンドを使用して、 GCP と認証を行います。

```
WIP
gcloud auth application-default login
```

## :whale: プロジェクトの設定

+ GCP 上で使用する、プロジェクトを先に指定しておきます。

```
export _pj='iganari_test-qr'

gcloud config set project ${_pj}
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
