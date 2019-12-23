# v3.3.0

## GKE構築方法(簡易版)

+ Repository を Clone します。

```
git clone https://github.com/iganari/package-gcp.git
```

+ ディレクトリを移動します。

```
cd package-gcp/kubernetes/sample-version
```

+ Docker コンテナを起動します ---> :whale:

```
sh docker-build-run.sh
```

+ :whale: ディレクトリを移動します。

```
cd v3_3_0
```

+ GCP との認証を行います
  + Terrform を使用するため、 `application-default` を使用します。

```
gcloud auth application-default login
```

+ :whale: Terraform のプロバイダーなどの準備をします。

```
terraform init
```

+ :whale: Terraform の設定ファイルの検証をします。

```
terraform validate
```

+ :whale: Terraform の Plan を実行します。

```
terraform plan
```

+ :whale: Terraform を実行します。

```
terraform apply
```

## GKE 確認方法

+ 手元の gcloud コマンドを使うための認証をします

```
gcloud auth login
```

+ 構築した GKE に対して、認証をします。

```
gcloud container clusters get-credentials ${GKE_cluster_name}
```
```
### 例

gcloud container clusters get-credentials tf-diff-v3 \
  --region us-central1
```

+ 構築した GKE の Node を確認します。

```
kubectl get nodes
OR
kubectl get nodes -o wide
```
