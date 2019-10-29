# sample-lifetime

## 準備

+ 作業用の Docker コンテナを起動する ---> :whale:

```
sh docker-build-run.sh
```

## :whale: gcloud のコンフィグの作成

```
export _setting_name='sample-lifetime'

gcloud config configurations create ${_setting_name}
```

## :whale: 認証


[IAM & admin](../../iam-admin/README.ja.md)


## :whale: プロジェクトの設定

+ 必須

```
export _pj='iganari_test-qr'
gcloud config set project ${_pj}
```

+ しなくてもよい

```
gcloud config set compute/region asia-northeast1
gcloud config set compute/zone asia-northeast1-a
```

+ Terraform の workspace の設定

```
terraform workspace new ${_pj}
terraform workspace select ${_pj}
terraform workspace show
```

+ 確認

```
gcloud config configurations list
```

## Terraform の実行

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
