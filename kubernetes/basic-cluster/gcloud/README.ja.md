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

## GKE の構築

+ gcloud コマンドの configure 機能を使用し設定を管理します
  + また、 GCP 上のプロジェクトID を使用します。
  
```
export _pj='GCP 上のプロジェクトID'
  
  
gcloud config configurations create ${_pj}
gcloud config set project ${_pj}
gcloud config configurations list
```

+ GCP の認証
  + ブラウザを通しての認証を行います。

```
gcloud auth login
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

+ 単一の Zone 内に Node を 1 台立ち上げます。
  + Zone は `us-central1-a` を指定します。 
  + 主に検証用として使って下さい。

+ 構築コマンド

```
gcloud beta container clusters create ${_common_name} \
  --network=${_common_name}-nw \
  --subnetwork=${_common_name}-sb \
  --zone us-central1-a \
  --num-nodes=1 \
  --preemptible
```

+ GKE との認証

```
gcloud container clusters get-credentials ${_common_name} \
  --zone us-central1-a
```


+ Node の確認

```
kubectl get node
OR
kubectl get node -o wide
```
```
$ kubectl get nodes
NAME                                         STATUS   ROLES    AGE   VERSION
gke-iganari-k8s-default-pool-bba6c328-pgtq   Ready    <none>   29s   v1.13.11-gke.14
```

### リージョナルクラスター

+ Region の中の Zone 毎に Node を 1 台立ち上げます。
  + Zone 障害に耐性が尽きますが、 Zone 毎に起動するのでコストが高くなります。
+ 構築コマンド

```
gcloud beta container clusters create ${_common_name} \
  --network=${_common_name}-nw \
  --subnetwork=${_common_name}-sb \
  --region us-central1 \
  --num-nodes=1 \
  --preemptible
```

+ GKE との認証

```
gcloud container clusters get-credentials ${_common_name} \
  --region us-central1
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

### K8s のバージョンを固定したい場合

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

## リソースの削除

### K8s クラスターの削除

+ ゾーンクラスタの場合

```
gcloud beta container clusters delete ${_common_name} \
  --zone us-central1-a
```

+ リージョナルクラスターの場合

```
gcloud beta container clusters delete ${_common_name} \
  --region us-central1
```

### ネットワークの削除

+ Firewall Rules を削除します。

```
gcloud compute firewall-rules delete ${_common_name}-nw-allow-internal
```

+ 実験用の VPC ネットワークとそれに付随するサブネットワークを削除します。

```
gcloud beta compute networks subnets delete ${_common_name}-sb \
  --region us-central1
```
```
gcloud beta compute networks delete ${_common_name}-nw
```
