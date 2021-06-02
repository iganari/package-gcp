# gcloud にて VPC ネイティブ クラスタの作成する

## これは何?

+ GKE を立ち上げる gcloud コマンドのサンプルです。
+ GKE を構築するまでの工程にフォーカスを当てています。

## gcloud コマンドで構築

+ 環境変数を設定します

```
### New Env

export _gcp_pj_id='Your GCP Project ID'
export _common='vpcnt-gcloud'
export _region='asia-northeast1'
export _sub_network_range='10.146.0.0/20'    ### VPCネットワークの default の値
```

+ GCP への認証します

```
gcloud auth login -q
```

+ ネットワークの作成します

```
### VPC 作成
gcloud beta compute networks create ${_common}-network \
  --subnet-mode=custom \
  --project ${_gcp_pj_id}


### サブネット作成
gcloud beta compute networks subnets create ${_common}-subnets \
  --network ${_common}-network \
  --region ${_region} \
  --range ${_sub_network_range} \
  --project ${_gcp_pj_id}
```

+ Firewall Rule の作成します

```
### 内部通信はすべて許可
gcloud beta compute firewall-rules create ${_common}-allow-internal-all \
  --direction=INGRESS \
  --priority=1000 \
  --network ${_common}-network \
  --action ALLOW \
  --rules tcp:0-65535,udp:0-65535,icmp \
  --source-ranges ${_sub_network_range} \
  --project ${_gcp_pj_id}
```

+ VPC ネイティブ クラスタの作成します
  + https://cloud.google.com/kubernetes-engine/docs/how-to/alias-ips
  + `--enable-ip-alias` を明示すれば良いです

```
### zonal を作成します
gcloud container clusters create ${_common}-cst \
  --zone ${_region}-a \
  --release-channel "rapid" \
  --enable-ip-alias \
  --network ${_common}-network \
  --subnetwork ${_common}-subnets \
  --cluster-ipv4-cidr "/17" \
  --services-ipv4-cidr "/22"\
  --num-nodes=1 \
  --preemptible \
  --project ${_gcp_pj_id}
```

---> ここまでで、1台構成のゾーンナルクラスターが出来るが、node-pool にデフォルトであたっているVMのタイプが `e2-medium` で使いづらいので、node-pool をつけ直します

```
### 新しい node pool の追加します
gcloud beta container node-pools create ${_common}-pool-1 \
  --cluster ${_common}-cst \
  --zone ${_region}-a \
  --machine-type "n1-standard-1" \
  --image-type "COS_CONTAINERD" \
  --preemptible \
  --num-nodes 2 \
  --enable-autoscaling \
  --min-nodes 2 \
  --max-nodes 10 \
  --enable-autoupgrade \
  --enable-autorepair \
  --max-surge-upgrade 2 \
  --max-unavailable-upgrade 0 \
  --project ${_gcp_pj_id}


### デフォルトで作られた node pool を削除します
gcloud beta container node-pools delete default-pool \
  --cluster ${_common}-cst \
  --zone ${_region}-a \
  --project ${_gcp_pj_id} \
  -q
```

## GKE にて作業をする

+ GKE クラスタに認証を通します

```
gcloud beta container clusters get-credentials ${_common}-cst \
  --zone ${_region}-a \
  --project ${_gcp_pj_id}
```

+ Pod や Node をチェックしてみます

```
kubectl get pod
kubectl get node
```

## pod をおいてみる

1. manifest を作る
1. kubectl run コマンドを使う

#### 1. manifest を作る

```
cat << __EOF__ > pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: test-pod
    image: ubuntu:focal-20210416
    command:
     - tail
     - -f
     - /dev/null
__EOF__
```

```
kubectl apply -f pod.yaml
```

#### 2. kubectl run コマンドを使う

```
kubectl run test-pod --image=ubuntu:focal-20210416 --command -- tail -f /dev/null
```

+ Pod にログインをします

```
kubectl exec -it test-pod /bin/bash
```
```
## パッケージのインストール
apt update
apt install -y traceroute iputils-ping iproute2 net-tools
```
```
## 外部への疎通確認
ping -c 3 yahoo.co.jp
```
```
exit
```

---> これで基本的な構成は出来ました :raised_hands:

## 実験

WIP

## リソースの削除

+ Pod を削除します

```
kubectl delete -f pod.yaml
```

+ GKE クラスタを削除します

```
gcloud container clusters delete ${_common}-cst \
  --zone ${_region}-a \
  --project ${_gcp_pj_id} \
  -q
```

+ Firewall Rule を削除します

```
gcloud beta compute firewall-rules delete ${_common}-allow-internal-all \
  --project ${_gcp_pj_id} \
  -q
```

+ ネットワークを削除します

```
### サブネットの削除
gcloud compute networks subnets delete ${_common}-subnets \
  --region ${_region} \
  --project ${_gcp_pj_id} \
  -q

### VPC ネットワークの削除
gcloud beta compute networks delete ${_common}-network \
  --project ${_gcp_pj_id} \
  -q
```

## ドキュメントリンク集

公式ドキュメント

+ https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-cluster
+ https://cloud.google.com/sdk/gcloud/reference/container/clusters/create
+ https://cloud.google.com/sdk/gcloud/reference/container/clusters/delete
