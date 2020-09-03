# Basic Sample gcloud of GKE

## これは何?

+ GKE を立ち上げる gcloud コマンドのサンプルです。
+ GKE を構築するまでの工程にフォーカスを当てています。

## どんな構成が作れるの??

+ GKE を ゾーンクラスタ と リージョン クラスタ で作成します。
  + [ゾーンクラスタ](https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-cluster)
  + [リージョン クラスタ](https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-cluster)
+ GKE クラスターを デフォルトの VPC ネットワークではなく、自分で作成した VPC ネットワークとサブネット上に構築します。
+ Node に使用する VM に プリミティブ VM インスタンスを指定しています。
  + [プリミティブ VM インスタンス](https://cloud.google.com/compute/docs/instances/preemptible)
+ Node のオートスケーリングは設定していません。
+ 起動する Node のスペックはデフォルトのままです。
  + デフォルトでは `n1-standard-1` になります。

## 説明

公式ドキュメント

+ https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-cluster
+ https://cloud.google.com/sdk/gcloud/reference/container/clusters/create
+ https://cloud.google.com/sdk/gcloud/reference/container/clusters/delete


## アカウント準備

+ GCP のアカウントを作成します。

```
ここは他の記事におまかせします。
```

+ GCP のプロジェクト作成

```
ここは他の記事におまかせします。
```

# GKE の構築

## ネットワークの作成

+ gcloud コマンドの configure 機能を使用し設定を管理します
  + また、 GCP 上のプロジェクトID を使用します。
  
```
### Add New Env
export _pj='GCP のプロジェクトID'
  
  
gcloud config configurations create ${_pj}
gcloud config set project ${_pj}
gcloud config configurations list
```

+ GCP の認証
  + ブラウザを通しての認証を行います。

```
gcloud auth login -q
```

+ 実験用の VPC ネットワークとそれに付随するサブネットワークを作成します。

```
### Add New Env
export _common='basic-gke'
export _region='asia-northeast1'
```
```
gcloud beta compute networks create ${_common}-network \
  --subnet-mode=custom \
  --project ${_pj}
```
```
gcloud beta compute networks subnets create ${_common}-subnets \
  --network ${_common}-network \
  --region ${_region} \
  --range 172.16.0.0/12 \
  --project ${_pj}
```

+ Firewall Rules を作成します。

```
gcloud beta compute firewall-rules create ${_common}-allow-internal-all \
  --network ${_common}-network \
  --allow tcp:0-65535,udp:0-65535,icmp \
  --project ${_pj}
```

## ゾーンナルクラスタ

+ 単一の Zone 内に Node を 3 台立ち上げます。
  + Zone は `asia-northeast1-a` を指定します。 
  + 主に検証用として使って下さい。

+ クラスタの作成

```
gcloud beta container clusters create ${_common}-zonal \
  --network ${_common}-network \
  --subnetwork ${_common}-subnets \
  --zone ${_region}-a \
  --num-nodes 3 \
  --preemptible \
  --project ${_pj}
```

+ ノードプールの作成

```
gcloud beta container node-pools create ${_common}-zonal-nodepool \
  --cluster ${_common}-zonal \
  --zone ${_region}-a \
  --num-nodes 3 \
  --preemptible \
  --project ${_pj}
```

+ デフォルトのノードプールの削除

```
gcloud beta container node-pools delete default-pool \
  --cluster ${_common}-zonal \
  --zone ${_region}-a \
  --project ${_pj}
```

+ GKE との認証

```
gcloud beta container clusters get-credentials ${_common}-zonal \
  --zone ${_region}-a \
  --project ${_pj}
```

+ Node の確認

```
kubectl get node
OR
kubectl get node -o wide
```
```
### Ex.

# kubectl get node -o wide
NAME                                                  STATUS   ROLES    AGE    VERSION          INTERNAL-IP   EXTERNAL-IP     OS-IMAGE                             KERNEL-VERSION   CONTAINER-RUNTIME
gke-basic-gke-zonal-basic-gke-zonal-n-da6ec9dd-8q7h   Ready    <none>   3m5s   v1.15.12-gke.2   172.16.0.21   35.200.77.146   Container-Optimized OS from Google   4.19.112+        docker://19.3.1
gke-basic-gke-zonal-basic-gke-zonal-n-da6ec9dd-fpns   Ready    <none>   3m7s   v1.15.12-gke.2   172.16.0.22   34.84.124.17    Container-Optimized OS from Google   4.19.112+        docker://19.3.1
gke-basic-gke-zonal-basic-gke-zonal-n-da6ec9dd-zkj2   Ready    <none>   3m5s   v1.15.12-gke.2   172.16.0.20   34.84.183.161   Container-Optimized OS from Google   4.19.112+        docker://19.3.1
```

## リージョナルクラスタ

+ Region の中の Zone 毎に Node を 1 台立ち上げます。
  + Zone 障害に耐性が着きます

+ クラスタの作成

```
gcloud beta container clusters create ${_common}-regional \
  --network ${_common}-network \
  --subnetwork ${_common}-subnets \
  --region ${_region} \
  --num-nodes 1 \
  --preemptible \
  --project ${_pj}
```

+ ノードプールの作成

```
gcloud beta container node-pools create ${_common}-regional-nodepool \
  --cluster ${_common}-regional \
  --region ${_region} \
  --num-nodes 1 \
  --preemptible \
  --project ${_pj}
```

+ デフォルトのノードプールの削除

```
gcloud beta container node-pools delete default-pool \
  --cluster ${_common}-regional \
  --region ${_region} \
  --project ${_pj}
```
```
gcloud beta container node-pools delete ${_common}-regional-nodepool \
  --cluster ${_common}-regional \
  --region ${_region} \
  --project ${_pj} -q
```

+ GKE との認証

```
gcloud beta container clusters get-credentials ${_common}-regional \
  --region ${_region} \
  --project ${_pj}
```

+ Node の確認

```
kubectl get node
OR
kubectl get node -o wide
```
```
$ kubectl get node
NAME                                         STATUS   ROLES    AGE    VERSION
gke-iganari-k8s-default-pool-4a9e4df1-k8l8   Ready    <none>   5m4s   v1.13.11-gke.14
```

## K8s のバージョンを固定したい場合

+ クラスタのバージョンをあえて、古いバージョンに指定して作製します。
  + 2019/11/18 現在は デフォルトのバージョンは `1.13.11-gke.14` であり、選択出来るバージョンで最も古いのは `1.12.10-gke.17` です。

+ 構築コマンド

```
gcloud beta container clusters create ${_common_name} \
  --network=${_common_name}-nw \
  --subnetwork=${_common_name}-sb \
  --zone us-central1-a \
  --num-nodes=1 \
  --preemptible \
  --cluster-version=1.12.10-gke.17
```

+ Node の確認

```
WIP
```

## Kubernetes との認証

GKE と認証が通ってないエラーが出た場合は、以下のコマンドで認証をしましょう。

+ GKE のクラスターとの認証をします。

```
gcloud auth login
gcloud config set compute/zone us-central1
gcloud container clusters get-credentials ${_common_name}
```

+ Node の確認

```
kubectl get node
OR
kubectl get node -o wide
```
```
### 例(リージョナルで作成した時)

$ kubectl get node
NAME                                         STATUS   ROLES    AGE   VERSION
gke-iganari-k8s-default-pool-483b7289-4cvc   Ready    <none>   50s   v1.13.11-gke.14
gke-iganari-k8s-default-pool-a6a52aa1-51b0   Ready    <none>   49s   v1.13.11-gke.14
gke-iganari-k8s-default-pool-e3f4e84e-1lk6   Ready    <none>   50s   v1.13.11-gke.14
```

# リソースの削除

## K8s クラスターの削除

+ ゾーンクラスタの場合

```
gcloud beta container clusters delete ${_common}-zonal \
  --zone ${_region}-a \
  --project ${_pj}
```

+ リージョナルクラスタの場合

```
gcloud beta container clusters delete ${_common}-regional \
  --region ${_region} \
  --project ${_pj}
```

## ネットワークの削除

+ Firewall Rules を削除します。

```
gcloud beta compute firewall-rules delete ${_common}-allow-internal-all \
  --project ${_pj}
```
```
gcloud compute firewall-rules create ${_common}-allow-internal-all \
  --network ${_common}-network \
  --allow tcp:0-65535,udp:0-65535,icmp \
  --project ${_pj}
```

+ 実験用の VPC ネットワークとそれに付随するサブネットワークを削除します。

```
gcloud beta compute networks subnets delete ${_common}-subnet \
  --region ${_region}
```
```
gcloud beta compute networks delete ${_common}-network
```
