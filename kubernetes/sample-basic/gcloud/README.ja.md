# Basic Sample gcloud of GKE

## これは何?

+ GKE を立ち上げる gcloud コマンドのサンプルです。
+ Deployment 等の管理はせず、あくまで GKE のみにフォーカスを当てています。

## 説明

公式ドキュメント

+ https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-cluster
+ https://cloud.google.com/sdk/gcloud/reference/container/clusters/create


## 準備

+ GCP のアカウントを作成します。

```
ここは他の記事におまかせします。
```

```
gcloud config set project [PROJECT_ID]
gcloud config set compute/zone [COMPUTE_ZONE]
gcloud config set compute/region [COMPUTE_REGION]
gcloud components update
```



## Cloud Shell 上でコマンドを実行

+ Node(n1-standard-1) が合計 3 個を起動する

```
gcloud beta container clusters create iganari-test-cli-1911 \
  --zone us-central1 \
  --num-nodes=1 \
  --release-channel stable \
  --preemptible 
```

## GKE との認証

+ GKE のクラスターとの認証をします。

```
gcloud auth login
gcloud config set compute/zone us-central1
gcloud container clusters get-credentials iganari-test-cli-1911
```

+ node の確認

```
kubectl get node
OR
kubectl get node -o wide
```
```
### 例

$ kubectl get node
NAME                                                  STATUS   ROLES    AGE     VERSION
gke-iganari-test-cli-191-default-pool-8e3fded4-g898   Ready    <none>   5m19s   v1.13.11-gke.14
gke-iganari-test-cli-191-default-pool-b2f227b2-gf81   Ready    <none>   5m19s   v1.13.11-gke.14
gke-iganari-test-cli-191-default-pool-fe9079b7-8k79   Ready    <none>   5m18s   v1.13.11-gke.14
```
