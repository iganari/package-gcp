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
