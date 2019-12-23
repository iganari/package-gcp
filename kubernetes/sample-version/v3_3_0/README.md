# v3.3.0

## 実行方法(簡易版)

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
