# Basic Sample gcloud of GKE

## これは何?

+ GKE を立ち上げる gcloud コマンドのサンプルです。
+ Deployment 等の管理はせず、あくまで GKE のみにフォーカスを当てています。

## どんな構成が作れるの??




## 説明

公式ドキュメント

+ https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-cluster
+ https://cloud.google.com/sdk/gcloud/reference/container/clusters/create


## アカウント準備

+ GCP のアカウントを作成します。

```
ここは他の記事におまかせします。
```

+ GCP のプロジェクト作成

```
ここは他の記事におまかせします。
```

```
gcloud config set project [PROJECT_ID]
gcloud config set compute/zone [COMPUTE_ZONE]
gcloud config set compute/region [COMPUTE_REGION]
gcloud components update
```

## GKE の構築

:warning: サンプルは Cloud Shell からの実行で動作確認しています。

+ GCP の認証
  + ブラウザを通しての認証を行います。

```
gcloud auth application-default login
```

+ gcloud コマンドの configure 機能を使用し設定を管理します
  + また、 GCP 上のプロジェクトID を使用します。
  
```
export _pj='GCP 上のプロジェクトID'
  
  
gcloud config configurations create ${_pj}
gcloud config set project ${_pj}
gcloud config configurations list
```

+ 実験用の VPC ネットワークとそれに付随するサブネットワークを作成します。

```
export _common_name='iganari-k8s'
```

```
gcloud beta compute networks create ${_common_name}-nw \
  --subnet-mode=custom
```
```
gcloud beta compute networks subnets create ${_common_name}-sb \
  --network ${_common_name}-nw \
  --region us-central1 \
  --range 172.16.0.0/12
```

+ Firewall Rules を作成します。

```
gcloud compute firewall-rules create ${_common_name}-nw-allow-internal \
  --network ${_common_name}-nw \
  --allow tcp:0-65535,udp:0-65535,icmp
```

### ゾーンナルクラスター


+ 単一の Zone に Node を 1 台立ち上げます
  + zone は us-central1-a
  + 主に検証用として使って下さい。

```
gcloud beta container clusters create ${_common_name} \
  --network=${_common_name}-nw \
  --subnetwork=${_common_name}-sb \
  --zone us-central1-a \
  --num-nodes=1 \
  --preemptible
```

+ 削除コマンド

```
gcloud beta container clusters delete ${_common_name} \
  --zone us-central1-a
```


### リージョナルクラスター

+ GKE を Node(n1-standard-1) が合計 3 個を起動します。
  + region で指定しているため、その region 毎に node が 1個立ち上がります
  + Node は preemptible instance を用います。

```
gcloud beta container clusters create ${_common_name} \
  --network=${_common_name}-nw \
  --subnetwork=${_common_name}-sb \
  --region us-central1 \
  --num-nodes=1 \
  --preemptible
```

+ kubectl コマンドにて確認を行います。
  + Node のバージョンが指定したバージョンになっていることを確認出来ました。

```
kubectl get nodes
NAME                                         STATUS   ROLES    AGE   VERSION
gke-no-downtime-default-pool-1894e82b-2b2j   Ready    <none>   57s   v1.12.10-gke.17
gke-no-downtime-default-pool-8d4eb0ed-78r1   Ready    <none>   57s   v1.12.10-gke.17
gke-no-downtime-default-pool-d5a8d6e0-vmvd   Ready    <none>   76s   v1.12.10-gke.17
```

+ 削除コマンド

```
gcloud beta container clusters delete ${_common_name} \
  --region us-central1
```


### K8s のバージョンを固定したい場合

+ GKE を Node(n1-standard-1) が合計 3 個を起動します。
  + region で指定しているため、その region 毎に node が 1個立ち上がります
  + Node は preemptible instance を用います。
  + クラスタのバージョンをあえて、古いバージョンに指定して作製します。
    + 2019/11/18 現在は デフォルトのバージョンは `1.13.11-gke.14` であり、選択出来るバージョンで最も古いのは `1.12.10-gke.17` です。



```
gcloud beta container clusters create ${_common_name} \
  --network=${_common_name}-nw \
  --subnetwork=${_common_name}-sb \
  --zone us-central1-a \
  --num-nodes=1 \
  --preemptible \
  --cluster-version=1.12.10-gke.17
```

## Kubernetes との認証

+ GKE のクラスターとの認証をします。

```
gcloud auth login
gcloud config set compute/zone us-central1
gcloud container clusters get-credentials ${_common_name}
```

+ node の確認

```
kubectl get node
OR
kubectl get node -o wide
```
```
### 例(リージョナルで作成した時)

$ kubectl get node
NAME                                                  STATUS   ROLES    AGE     VERSION
gke-iganari-test-cli-191-default-pool-8e3fded4-g898   Ready    <none>   5m19s   v1.13.11-gke.14
gke-iganari-test-cli-191-default-pool-b2f227b2-gf81   Ready    <none>   5m19s   v1.13.11-gke.14
gke-iganari-test-cli-191-default-pool-fe9079b7-8k79   Ready    <none>   5m18s   v1.13.11-gke.14
```

## クラスターの削除

```
gcloud beta container clusters delete iganari-test-cli-1911 \
  --zone us-central1
```
```
gcloud beta container clusters delete ${_common_name} \
  --zone us-central1-a
```

