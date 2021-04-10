# Cloud SQL by Terraform

## 公式ドキュメント

WIP

## このディレクトリの概要

+ Cloud SQL をさまざまな形で立ててみる
  + ha
  + readreplica
  + ha-readreplica

## 構築方法

```
git clone https://WIP
cd package-gcp
```

+ Docker コンテナの起動 ---> :whale:

```
sh docker-build-run.sh
```

+ :whale: gcloud コマンドのアップデート

```
gcloud --quiet components update
gcloud --quiet components install beta
```

あとは {ha|readreplica|ha-readreplica} の環境に行き、Terraform を実行します。

### ha を行う場合


```
gcloud auth application-default login
```


```
cd sql/terraform/env/ha
```

```
export _pj='sample-gcp-project'

terraform workspace new ${_pj}
terraform workspace list

terraform init
terraform validate
terraform plan
terraform apply
```

## 実験

As you Like ... 

## 検証後

+ :whale: リソースの削除

```
terraform destroy
```

+ Docker コンテナから出る

```
exit
```