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

+ デフォルトのノードプールの削除

```
gcloud beta container node-pools delete default-pool \
  --cluster ${_common}-zonal \
  --zone ${_region}-a \
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

+ デフォルトのノードプールの削除

```
gcloud beta container node-pools delete default-pool \
  --cluster ${_common}-regional \
  --region ${_region} \
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
### Ex.

# kubectl get node -o wide
NAME                                                  STATUS   ROLES    AGE   VERSION          INTERNAL-IP   EXTERNAL-IP     OS-IMAGE                             KERNEL-VERSION   CONTAINER-RUNTIME
gke-basic-gke-region-basic-gke-region-1b0af31f-0jks   Ready    <none>   92s   v1.15.12-gke.2   172.16.0.25   35.243.72.138   Container-Optimized OS from Google   4.19.112+        docker://19.3.1
gke-basic-gke-region-basic-gke-region-85628f84-8sbs   Ready    <none>   98s   v1.15.12-gke.2   172.16.0.23   34.84.183.161   Container-Optimized OS from Google   4.19.112+        docker://19.3.1
gke-basic-gke-region-basic-gke-region-d598db0e-gblr   Ready    <none>   92s   v1.15.12-gke.2   172.16.0.24   34.84.11.94     Container-Optimized OS from Google   4.19.112+        docker://19.3.1
```

## GKE のリリースチャンネルを指定する

+ 指定出来るリリースチャンネルの確認

```
gcloud beta container get-server-config --region ${_region}
```
```
### Ex.

# gcloud beta container get-server-config --region ${_region}
channels:
- channel: RAPID
  defaultVersion: 1.17.9-gke.1503
  validVersions:
  - 1.17.9-gke.1503
- channel: REGULAR
  defaultVersion: 1.16.13-gke.1
  validVersions:
  - 1.16.13-gke.1
- channel: STABLE
  defaultVersion: 1.15.12-gke.2
  validVersions:
  - 1.15.12-gke.9
  - 1.15.12-gke.2
```

+ クラスタの作成
  + `RAPID` を指定する

```
gcloud beta container clusters create ${_common}-spver \
  --network ${_common}-network \
  --subnetwork ${_common}-subnets \
  --region ${_region} \
  --num-nodes 1 \
  --preemptible \
  --release-channel rapid \
  --project ${_pj}
```

+ デフォルトのノードプールの削除

```
gcloud beta container node-pools delete default-pool \
  --cluster ${_common}-spver \
  --region ${_region} \
  --project ${_pj}
```

+ ノードプールの作成

```
gcloud beta container node-pools create ${_common}-spver-nodepool \
  --cluster ${_common}-spver \
  --region ${_region} \
  --num-nodes 1 \
  --preemptible \
  --project ${_pj}
```

+ GKE との認証

```
gcloud beta container clusters get-credentials ${_common}-spver \
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
### Ex.

# kubectl get node -o wide
NAME                                                  STATUS   ROLES    AGE   VERSION            INTERNAL-IP   EXTERNAL-IP      OS-IMAGE                             KERNEL-VERSION   CONTAINER-RUNTIME
gke-basic-gke-spver-basic-gke-spver-n-8b5878f5-j8hq   Ready    <none>   79s   v1.17.9-gke.1503   172.16.0.45   35.200.77.146    Container-Optimized OS from Google   4.19.112+        docker://19.3.6
gke-basic-gke-spver-basic-gke-spver-n-b46157e3-909w   Ready    <none>   71s   v1.17.9-gke.1503   172.16.0.46   35.243.72.138    Container-Optimized OS from Google   4.19.112+        docker://19.3.6
gke-basic-gke-spver-basic-gke-spver-n-e77d6153-cjhx   Ready    <none>   74s   v1.17.9-gke.1503   172.16.0.44   35.243.127.218   Container-Optimized OS from Google   4.19.112+        docker://19.3.6
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

+ リリースチャンネルを指定したクラスタ(zonal)を削除する

```
gcloud beta container clusters delete ${_common}-spver \
  --region ${_region} \
  --project ${_pj}
```


## ネットワークの削除

+ Firewall Rules を削除

```
gcloud beta compute firewall-rules delete ${_common}-allow-internal-all \
  --project ${_pj}
```

+ VPC ネットワークとそれに付随するサブネットワークを削除

```
gcloud beta compute networks subnets delete ${_common}-subnets \
  --region ${_region}
```
```
gcloud beta compute networks delete ${_common}-network
```
