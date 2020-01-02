# Basic Sample Terraform of GKE

## これは何?

+ GKE を立ち上げる Terraform のサンプルです。
+ Deployment 等の管理はせず、あくまで GKE のみにフォーカスを当てています。

## 説明

基本的なところは Terraform の公式ドキュメントに沿っています。

+ https://www.terraform.io/docs/providers/google/r/container_cluster.html

しかし、以下の点は上記の公式ドキュメントのサンプルから変更しています。

+ Master Node と Node pool のネットワークを分離
  + [here](container_cluster.tf#L20-L21)
+ ノードのオートスケールを設定
  + [here](container_node_pool.tf#L11-L15)
+ デフォルトの VPCネットワークを使わない
  + [here](compute_network.tf)
+ Node のオートヒーリングの設定
  + [here](container_node_pool.tf#L17-L19)


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

+ gcloud には 設定のセットをローカルに保持して管理することが出来ます。
  + [gcloud config configurations ](https://cloud.google.com/sdk/gcloud/reference/config/configurations/)
  + ここではプロジェクトを同じ名前の設定を作成する例を記載します。
  + GCP 上のプロジェクト名 = `iganari-gke-sample-basic` とします。

```
export _pj='iganari-gke-sample-basic'

gcloud config configurations create ${_pj}
gcloud config configurations select ${_pj}
gcloud config configurations list
```

## :whale: gcloud コマンドによる認証

+ ブラウザを介して、認証を行います。

```
gcloud auth application-default login
```

## :whale: プロジェクトの設定

+ gcloud コマンドのプロジェクトの設定をします。

```
gcloud config set project ${_pj}
```

+ Terraform の workspace の設定をします。
  + Terraform には workspace という機能があり、それを用います。

```
terraform workspace new ${_pj}
terraform workspace select ${_pj}
```

+ Terraform の workspace の確認をします。

```
terraform workspace show
```

+ gcloud コマンドの設定の確認をします。

```
gcloud config configurations list
```
```
### 例

# gcloud config configurations list
NAME                      IS_ACTIVE  ACCOUNT  PROJECT                   DEFAULT_ZONE  DEFAULT_REGION
iganari-gke-sample-basic  True                iganari-gke-sample-basic
```

## Terraform で GCP にデプロイ

+ init
  + 今回は初回実行のみ行います。

```
terraform init
```

+ validate
  + 記法に誤りが無いか確認します。

```
terraform plan
```

+ plan
  + 作成予定のリソースを表示します。

```
terraform plan
```

+ apply
  + 実際にリソースをデプロイします。

```
terraform apply
```

## GKE との認証

+ GKE のクラスターとの認証をします。
  + [name](container_cluster.tf#L5) ここで設定したものです。

```
gcloud auth login
gcloud config set compute/zone us-central1
gcloud container clusters get-credentials iganari-k8s-primary
```

+ node の確認

```
kubectl get node
OR
kubectl get node -o wide
```
```
### 例

# kubectl get node
NAME                                                  STATUS   ROLES    AGE     VERSION
gke-iganari-k8s-prim-iganari-k8s-node-074551cf-9qjr   Ready    <none>   2m35s   v1.13.11-gke.9
gke-iganari-k8s-prim-iganari-k8s-node-3899e3c5-djr6   Ready    <none>   2m32s   v1.13.11-gke.9
gke-iganari-k8s-prim-iganari-k8s-node-68f4f800-fk73   Ready    <none>   2m33s   v1.13.11-gke.9
```

---> これで GKE のサンプル作成は完成です!! 🙌

## Terraform でリソースの削除

```
terraform destroy
```

## まとめ

+ GKE として新しい機能が追加され、良さそうなものがあれば追記していきます。
+ このディレクトリは GKE の構築までなので、 Kubernetes のサンプルコードは別のディレクトリにてサンプルを作成します。 
