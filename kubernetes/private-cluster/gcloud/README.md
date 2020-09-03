# gcloud コマンドを用いて、限定公開クラスタを構築する

公式ドキュメント

+ https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters?hl=en#custom_subnet

## 構築作業

1. [gcloud コマンドの設定](./README.md#set-gcloud-command)
1. [VPC network の作成](./README.md#create-network)
1. [GKE の Cluster の作成](./README.md#create-regional-cluster)
1. [Cluster と認証する](./README.md#auth-cluster)
1. [リソースの削除](./README.md#delete-resource)

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

## Create Network

```
### Add New Env
export _common='private-gke'
export _region='asia-northeast1'
```

+ VPC ネットワークを作成します。

```
gcloud beta compute networks create ${_common}-network \
  --subnet-mode=custom \
  --project ${_pj}
```

+ サブネットワークを作成します。

```
gcloud beta compute networks subnets create ${_common}-subnets \
  --network ${_common}-network \
  --region ${_region} \
  --range 172.16.0.0/12 \
  --secondary-range pods-range=10.4.0.0/14,services-range=10.0.32.0/20 \
  --enable-private-ip-google-access
```

+ Firewall Rules を作成します。

```
gcloud beta compute firewall-rules create ${_common}-allow-internal-all \
  --network ${_common}-network \
  --allow tcp:0-65535,udp:0-65535,icmp \
  --project ${_pj}
```

## Create Regional Cluster

+ Private Cluster (リージョナル) を構築します。

```
gcloud beta container clusters create ${_common}-regional \
  --region ${_region} \
  --enable-master-authorized-networks \
  --network ${_common}-network \
  --subnetwork ${_common}-subnets \
  --cluster-secondary-range-name pods-range \
  --services-secondary-range-name services-range \
  --enable-private-nodes \
  --enable-ip-alias \
  --master-ipv4-cidr 192.168.100.0/28 \
  --no-enable-basic-auth \
  --no-issue-client-certificate \
  --num-nodes=1 \
  --release-channel stable \
  --preemptible \
  --project ${_pj}
```

## auth cluster

+ マスター承認ネットワークを設定します。

```
gcloud container clusters update ${_common}-regional \
    --region ${_region} \
    --enable-master-authorized-networks \
    --master-authorized-networks [EXISTING_AUTH_NETS],[SHELL_IP]/32
```
```
### 例

# 自分の環境の外部 IP アドレスを確認します。
## Cloud Shell の場合
dig +short myip.opendns.com @resolver1.opendns.com
## 上記以外の場合
curl ipaddr.io

# マスター承認ネットワークの設定をします。
gcloud container clusters update ${_common}-regional \
    --region ${_region} \
    --enable-master-authorized-networks \
    --master-authorized-networks 126.73.72.145/32
```

+ Cloud Router を作成します

```
gcloud compute routers create ${_common}-nat-router \
  --network ${_common}-network \
  --project ${_pj}
```

+ Cloud NAT を作成します

```
gcloud compute routers nats create ${_common}-nat-config \
  --router-region ${_region} \
  --router ${_common}-nat-router \
  --nat-all-subnet-ip-ranges \
  --auto-allocate-nat-external-ips \
  --project ${_pj}
```

+ GKE と承認をします。

```
gcloud container clusters get-credentials ${_common}-cls \
  --region ${_region} \
  --project ${_pj}
```

+ Node を確認をします。

```
kubectl get no
```
```
### 例

# kubectl get no
NAME                                                  STATUS   ROLES    AGE   VERSION
gke-iganari-privcls-gclo-default-pool-6f14bb95-nm0z   Ready    <none>   11m   v1.15.12-gke.2
gke-iganari-privcls-gclo-default-pool-92f6783b-7cnp   Ready    <none>   11m   v1.15.12-gke.2
gke-iganari-privcls-gclo-default-pool-bdcc9b08-wb1k   Ready    <none>   11m   v1.15.12-gke.2
```

+ Pod を確認します。

```
kubectl get po
```
```
# kubectl get po
No resources found in default namespace.
```

## Kubernetes を使ってみる

適当にサンプルを実行してみて下さい。

( もし特段思い浮かばなければ、[sample_guestbook](https://github.com/iganari/package-kubernetes/tree/master/sample_guestbook) や [sample_vote](https://github.com/iganari/package-kubernetes/tree/master/sample_vote) をやってみて下さい :)

## Delete Resource

+ GKE を削除します。

```
gcloud container clusters delete ${_common}-regional \
  --region ${_region} \
  --project ${_pj}
```

+ Cloud NAT を削除します。

```
gcloud compute routers nats delete ${_common}-nat-config \
  --router-region ${_region} \
  --router ${_common}-nat-router \
  --project ${_pj}
```

+ Cloud Router を削除します。

```
gcloud compute routers delete ${_common}-nat-router \
  --project ${_pj}
```

+ サブネットワークの削除します。

```
gcloud beta compute networks subnets delete ${_common}-subnet \
  --region ${_region} \
  --project ${_pj}
```

+ VPC ネットワークを削除します。

```
gcloud beta compute networks delete ${_common}-network \
  --project ${_pj}
```

## closing

Have Fan :)
