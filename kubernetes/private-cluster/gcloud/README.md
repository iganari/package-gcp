# gcloud コマンドを用いて、限定公開クラスタを構築する

公式ドキュメント

+ https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters?hl=en#custom_subnet

## 構築作業

1. [gcloud コマンドの設定](./README.md#set-gcloud-command)
1. [VPC network の作成](./README.md#create-network)
1. [GKE の Cluster の作成](./README.md#create-regional-cluster)
1. [Cluster と認証する](./README.md#auth-cluster)
1. [リソースの削除](./README.md#delete-resource)

## Set gcloud Command

+ 環境変数を設定

```
### New Env

export _pj='{Your GCP Project ID}'
export _common='iganari-privcls-gcloud'
export _region='asia-northeast1'
```

+ gcloud コマンドの設定

```
gcloud config configurations create ${_pj}

gcloud config set compute/region ${_region}
gcloud config set compute/zone ${_region}-a
gcloud config set project ${_pj}
```

+ gcloud の設定を確認します。

```
gcloud config configurations list
```

+ GCP と認証をします。
  + Web ブラウザ経由で認証をします。

```
gcloud auth login -q
```

## Create Network

+ VPC ネットワークを作成します。

```
gcloud beta compute networks create ${_common}-network \
  --subnet-mode=custom
```

+ サブネットワークを作成します。

```
gcloud beta compute networks subnets create ${_common}-subnet \
  --network ${_common}-network \
  --region ${_region} \
  --range 192.168.0.0/20 \
  --secondary-range pods-range=10.4.0.0/14,services-range=10.0.32.0/20 \
  --enable-private-ip-google-access
```

## Create Regional Cluster

+ Private Cluster (リージョナル) を構築します。

```
gcloud beta container clusters create ${_common}-cls \
    --region ${_region} \
    --enable-master-authorized-networks \
    --network ${_common}-network \
    --subnetwork ${_common}-subnet \
    --cluster-secondary-range-name pods-range \
    --services-secondary-range-name services-range \
    --enable-private-nodes \
    --enable-ip-alias \
    --master-ipv4-cidr 172.16.0.16/28 \
    --no-enable-basic-auth \
    --no-issue-client-certificate \
    --num-nodes=1 \
    --release-channel stable \
    --preemptible
```


## auth cluster

+ マスター承認ネットワークを設定します。

```
gcloud container clusters update ${_common}-cls \
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
gcloud container clusters update ${_common}-cls \
    --region ${_region} \
    --enable-master-authorized-networks \
    --master-authorized-networks 126.73.72.145/32
```

+ Cloud Router を作成します

```
gcloud compute routers create nat-router \
  --network ${_common}-network
```

+ Cloud NAT を作成します

```
gcloud compute routers nats create nat-config \
    --router-region ${_region} \
    --router nat-router \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips
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
gcloud container clusters delete ${_common}-cls \
    --region ${_region}
```

+ Cloud NAT を削除します。

```
gcloud compute routers nats delete nat-config \
    --router-region ${_region} \
    --router nat-router
```

+ Cloud Router を削除します。

```
gcloud compute routers delete nat-router
```

+ サブネットワークの削除します。

```
gcloud beta compute networks subnets delete ${_common}-subnet \
    --region ${_region}
```

+ VPC ネットワークを削除します。

```
gcloud beta compute networks delete ${_common}-network
```

## closing

Have Fan :)
