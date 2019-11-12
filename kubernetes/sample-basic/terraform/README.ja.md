# basic sample of GKE

WIP
## これは何?

+ GKE を立ち上げる Terraform のサンプルです。
+ Deployment 等の管理はせず、あくまで GKE のみにフォーカスを当てています。

## 説明

基本的なところは Terraform の公式ドキュメントに沿っています。

+ https://www.terraform.io/docs/providers/google/r/container_cluster.html

しかし、以下の点は上記の公式ドキュメントのサンプルから変更しています。

+ Master Node と Node pool のネットワークを分離
+ ノードのオートスケールを設定

## 準備

+ GCP のアカウントを作成します。

```
ここは他の記事におまかせします。
```

+ Repository を clone し、作業ディレクトリに移動します。

```
git clone https://github.com/iganari/package-gcp.git
```

+ 作業用の Docker コンテナを起動します。 ---> :whale:
  + 以降は :whale: が付いているコマンドはこの Docker コンテナの中で実行しています。

```
cd package-gcp/kubernetes/sample-basic/terraform/
sh docker-build-run.sh
```

## :whale: gcloud のコンフィグの作成

+ gcloud には 設定をローカルに保持する機能があり、ラベルみたいなもので紐付け、管理することが出来ます(WIP)
  + ここではプロジェクトを同じ名前の設定を作成する例を記載します
  + GCP 上のプロジェクト名 = `iganari-gke-sample-basic`

```
export _pj='iganari-gke-sample-basic'

gcloud config configurations create ${_pj}
gcloud config configurations list
```

## :whale: gcloud コマンドによる認証

+ ブラウザを介して、認証を行います。

```
gcloud auth application-default login
```

## :whale: プロジェクトの設定

+ gcloud コマンドのプロジェクトの設定をします

```
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

## GKE との認証

```
gcloud auth login
gcloud config set compute/zone us-central1
gcloud container clusters get-credentials igrs-test
```

+ node の確認

```
kubectl get node
OR
kubectl get node -o wide
```

## Terraform で リソースの削除

```
terraform destroy
```
