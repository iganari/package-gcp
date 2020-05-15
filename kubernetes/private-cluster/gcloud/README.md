# gcloud コマンドを用いて、限定公開クラスタを構築する

## 構築作業

+ Docker コンテナを起動する ---> :whale:

```
sh docker-build-run.sh
```

+ :whale: gcloud の設定を先にいれます。

```
### ここはよしなに変更して下さい

export _pj='{Your GCP Project ID}'
export _common='iganari-privcls-gcloud'
export _region='us-central1'
```

```
gcloud config configurations create ${_pj}

gcloud config set compute/region ${_region}
gcloud config set compute/zone us-central1-a
gcloud config set project ${_pj}
```

+ :whale: gcloud の設定を確認します。

```
gcloud config configurations list
```

+ :whale: GCP と認証をします。
  + Web ブラウザ経由で認証をします。

```
gcloud auth login
```

+ :whale: VPC ネットワークを作成します。

```
gcloud beta compute networks create ${_common}-nw \
  --subnet-mode=custom
```

+ :whale: サブネットワークを作成します。

```
gcloud beta compute networks subnets create ${_common}-sb \
  --network ${_common}-nw \
  --region ${_region} \
  --range 192.168.0.0/20 \
  --secondary-range pods-range=10.4.0.0/14,services-range=10.0.32.0/20 \
  --enable-private-ip-google-access
```

+ :whale: Private Cluster (リージョナル) を構築します。

```
gcloud beta container clusters create ${_common}-cls \
    --region ${_region} \
    --enable-master-authorized-networks \
    --network ${_common}-nw \
    --subnetwork ${_common}-sb \
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

+ :whale: Cloud Router を作成します。

```
gcloud compute routers create nat-router \
  --network ${_common}-nw
```

+ :whale: Cloud NAT を作成します。

```
gcloud compute routers nats create nat-config \
    --router-region ${_region} \
    --router nat-router \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips
```

---> ここまでで構築作業が完了です。

## 認証作業

+ :whale: マスター承認ネットワークを設定します。

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

+ :whale: GKE と承認をします。

```
gcloud container clusters get-credentials ${_common}-cls \
    --region ${_region} \
    --project ${_pj}
```

+ :whale: Node を確認をします。

```
kubectl get no
```
```
### 例

WIP
```

+ :whale: Pod を確認します。

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

## 削除作業

+ :whale: GKE を削除します。

```
gcloud container clusters delete ${_common}-cls \
    --region ${_region}
```

+ :whale: Cloud NAT を削除します。

```
gcloud compute routers nats delete nat-config \
    --router-region ${_region} \
    --router nat-router
```

+ :whale: Cloud Router を削除します。

```
gcloud compute routers delete nat-router
```

+ :whale: サブネットワークの削除します。

```
gcloud beta compute networks subnets delete ${_common}-sb \
    --region ${_region}
```

+ :whale: VPC ネットワークを削除します。

```
gcloud beta compute networks delete ${_common}-nw
```
