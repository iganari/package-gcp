# Sample Basic

## これは何?

Google Cloud Storage にイメージをアップロードする基本的なコードです。

## 準備

+ GCP のアカウントを作成します。
  + ここは他の記事におまかせします。

+ Repository を clone し、作業ディレクトリに移動します。

```
git clone --branch master --depth 1 https://github.com/iganari/package-gcp.git
```

+ GCP 上でサンプルのプロジェクトを作成し、 Service Account を作成します。
  + 付与する権限は、 {A|B|C} でこのコードは実行可能です。[WIP]
  + JSON の鍵を取得しておきます。

+ 上記で取得した鍵を以下の PATH に以下の名前で配置します。

```
cd storage/sample-basic/
touch service_account.json
```


+ 作業用の Docker コンテナを起動します。 ---> :whale:
  + 以降は :whale: が付いているコマンドはこの Docker コンテナの中で実行しています。

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

+ Service accounts を使用するため、不要です(たぶん)

```
+ https://cloud.google.com/iam/docs/service-accounts?hl=ja
+ 上記を参考に Service account key を発行して、
```


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
