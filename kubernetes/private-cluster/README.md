# 限定公開クラスタの設定 (Creating a private cluster)

## これは何？

公式ドキュメント

+ https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters

どんなものなの??

+ 他の VPC ネットワークから隔離したネットワーク上に K8s を展開します
+ 限定公開クラスタ内の Node 及び、 Pod から外にアクセスする場合は、 ロードバランサ経由で外部からアクセスを受信出来ます。


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
      + iganari-gke-private-clusters
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
NAME                          IS_ACTIVE  ACCOUNT                     PROJECT                   DEFAULT_ZONE  DEFAULT_REGION
iganari-gke-private-clusters  True       iganari@example.com  iganari-gke-sample-basic  us-central1   us-central1-a
```

## Creating a private cluster with limited access to the public endpoint

+ チュートリアル通りに GKE を作ると `n1-standard-1` が 9 台立ち上がってしましいます

```
### 例

gcloud container clusters create private-cluster-0 \
  --create-subnetwork name=my-subnet-0 \
  --enable-master-authorized-networks \
  --enable-ip-alias \
  --enable-private-nodes \
  --master-ipv4-cidr 172.16.0.0/28 \
  --no-enable-basic-auth \
  --no-issue-client-certificate
```

+ 故に、上記をミニマムで作ってみます。
  + `n1-standard-1` が 3 台 + preemptible インスタンスを使用します。
  + `gcloud beta` コマンドを使用します
  + Node は preemptible instance を用います。
  + GKE cluster 名 
    + private-cluster-0

+ この限定公開クラスタ用の VPC ネットワークを作成します。

```
gcloud beta compute networks create private-cluster-0-nw \
  --subnet-mode=custom
```

+ Firewall Rules を作成します。

```
gcloud compute firewall-rules create private-cluster-0-nw-allow-internal \
  --network private-cluster-0-nw  \
  --allow tcp:0-65535,udp:0-65535,icmp
```

+ 限定公開クラスタの GKE を作成します。

```
gcloud beta container clusters create private-cluster-0 \
  --network private-cluster-0-nw \
  --create-subnetwork name=my-subnet-0 \
  --enable-master-authorized-networks \
  --enable-ip-alias \
  --enable-private-nodes \
  --master-ipv4-cidr 172.16.0.0/28 \
  --no-enable-basic-auth \
  --no-issue-client-certificate \
  --num-nodes=1 \
  --release-channel stable \
  --preemptible 
```

+ Cloud Shell から、限定公開クラスタに対して、疎通を許可するコマンドを実行します。

```
dig +short myip.opendns.com @resolver1.opendns.com
```
```
### 例

$ dig +short myip.opendns.com @resolver1.opendns.com
104.199.171.167
```
```
gcloud container clusters update private-cluster-0 \
    --enable-master-authorized-networks \
    --master-authorized-networks [EXISTING_AUTH_NETS],[SHELL_IP]/32
```
```
### 例

$ gcloud container clusters update private-cluster-0 \
    --enable-master-authorized-networks \
    --master-authorized-networks 104.199.171.167/32
```

+ GKE との認証を gcloud コマンド経由で行います

```
gcloud container clusters get-credentials private-cluster-0 \
    --project ${_pj}
```

+ Node の確認

```
kubectl get nodes
```
```
### 例

$ kubectl get nodes
NAME                                               STATUS   ROLES    AGE   VERSION
gke-private-cluster-0-default-pool-5bb7017b-x7lf   Ready    <none>   32m   v1.13.11-gke.14
gke-private-cluster-0-default-pool-71736f9d-x5fx   Ready    <none>   32m   v1.13.11-gke.14
gke-private-cluster-0-default-pool-96dab18f-t59k   Ready    <none>   32m   v1.13.11-gke.14
```

+ ここまでで、限定公開クラスタは作成完了。
+ 以降は、限定公開クラスタを一般公開するための作業です


## リソースの削除

+ K8s クラスターの削除します。

```
gcloud container clusters delete private-cluster-0 \
    --zone us-central1-a
```

+ Firewall Rule を削除します。

```
gcloud compute firewall-rules delete private-cluster-0-nw-allow-internal
```

+ VPC ネットワークを削除します。

```
gcloud beta compute networks delete private-cluster-0-nw
```
