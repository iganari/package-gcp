# Basic Sample gcloud of GKE

## これは何?

+ GKE を立ち上げる gcloud コマンドのサンプルです。
+ Deployment 等の管理はせず、あくまで GKE のみにフォーカスを当てています。

## 説明

公式ドキュメント

+ https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-cluster
+ https://cloud.google.com/sdk/gcloud/reference/container/clusters/create


## 準備

+ GCP のアカウント作成

```
他の参考資料に任せます
```

+ gcloud には 設定のセットをローカルに保持して管理することが出来ます。
  + [gcloud config configurations]
  + ここではプロジェクトを同じ名前の設定を作成する例を記載します。
  + GCP 上で以下のようなステータスで作成していきます。
    + プロジェクト名
      + iganari-gke-sample-basic
    + region
      + us-central1
    + zone
      + us-central1-a


```
export _pj='iganari-gke-sample-basic'

gcloud config configurations create ${_pj}
gcloud config configurations list

gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a
gcloud config set project ${_pj}

gcloud auth login
```

```
$ gcloud config configurations list
NAME                      IS_ACTIVE  ACCOUNT                     PROJECT                   DEFAULT_ZONE  DEFAULT_REGION
iganari-gke-sample-basic  True       iganari@example.com         iganari-gke-sample-basic  us-central1   us-central1-a
```

## Cloud Shell 上でコマンドを実行

+ 専用の VPC ネットワークを作成します。
  + VPC ネットワーク名
    + iganari-gke-sample-basic-nw
  + サブネットワーク名
    + iganari-gke-sample-basic-sb
  + Firewall rule 名
    + iganari-gke-sample-basic-nw-allow-internal

```
gcloud beta compute networks create iganari-gke-sample-basic-nw \
  --subnet-mode=custom
```
```
gcloud compute networks subnets create iganari-gke-sample-basic-sb \
  --network iganari-gke-sample-basic-nw \
  --region us-central1 \
  --range 172.16.0.0/12
```
```
gcloud compute firewall-rules create iganari-gke-sample-basic-nw-allow-internal \
  --network iganari-gke-sample-basic-nw \
  --allow tcp:0-65535,udp:0-65535,icmp
```

+ GKE を Node(n1-standard-1) が合計 3 個を起動します。
  + Node は preemptible instance を用います。
  + GKE cluster 名
    + iganari-gke-sample-basic-k8s

```
gcloud beta container clusters create iganari-gke-sample-basic-k8s \
  --network=iganari-gke-sample-basic-nw \
  --subnetwork=iganari-gke-sample-basic-sb \
  --zone us-central1 \
  --num-nodes=1 \
  --release-channel stable \
  --preemptible 
```
```
### 例

$ gcloud beta container clusters create iganari-gke-sample-basic-k8s \
>   --network=iganari-gke-sample-basic-nw \
>   --subnetwork=iganari-gke-sample-basic-sb \
>   --zone us-central1 \
>   --num-nodes=1 \
>   --release-channel stable \
>   --preemptible
.
.
.
割愛
.
.
.
NAME                          LOCATION     MASTER_VERSION  MASTER_IP      MACHINE_TYPE   NODE_VERSION    NUM_NODES  STATUS
iganari-gke-sample-basic-k8s  us-central1  1.13.11-gke.14  35.202.54.141  n1-standard-1  1.13.11-gke.14  3          RUNNING
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

## リソースの削除

+ GKE クラスターの削除

```
gcloud beta container clusters delete iganari-gke-sample-basic-k8s \
  --zone us-central1
```

+ VPC ネットワークの削除
  + サブネットも同時に削除します。

```
gcloud beta compute networks delete hgoehoge
```


```



