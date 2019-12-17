# High Availability Sample

## ドキュメント

+ 高可用性構成の概要
  + https://cloud.google.com/sql/docs/mysql/high-availability
  + https://cloud.google.com/sql/docs/mysql/high-availability?hl=ja

## 概要

+ ファイルオーバー用の CloudSQL を作成する HA 構成を作成してみる

## 構築ハンズオン

+ Docker の起動します。
  + 以降は Docker コンテナ内から実行する想定です。 ---> :whale:

```
sh docker-build-run.sh
```

+ GCP と認証を行います。

```
gcloud auth application-default login
```

+ Terraform の workspace を作成します。
  + 既存の GCP プロジェクト ID を Terraform の workspace 名に設定してしまいます。

```
export _pj='既存の GCP プロジェクト ID'
gcloud config set project ${_pj}
```

+ Terraform の workspace を設定します。

```
terraform workspace new ${_pj}
terraform workspace select ${_pj}
terraform workspace show
```

+ Terraform を実行します。

```
terraform init
```


```
terraform plan
```

```
terraform apply
```



## HA を試してみる

WIP

