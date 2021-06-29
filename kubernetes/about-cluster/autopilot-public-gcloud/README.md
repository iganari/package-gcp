# Create Public Cluster of Autopilot mode

## キーワード

```
Autopilot mode
Public Cluster
```

## 実際に作ってみる

+ GCP と認証します

```
gcloud auth login -q
```

```
### Env

export _common='pubauto'
export _gcp_pj_id='Your GCP Project ID'
export _region='asia-northeast1'
export _sub_network_range='10.146.0.0/20'

export _gcp_pj_id='ca-corporate-website-dev2'
```

+ ネットワークを作成します

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

### 内部通信はすべて許可
gcloud beta compute firewall-rules create ${_common}-allow-internal-all \
  --network ${_common}-network \
  --action ALLOW \
  --rules tcp:0-65535,udp:0-65535,icmp \
  --source-ranges ${_sub_network_range} \
  --target-tags ${_common}-allow-internal-all \
  --project ${_gcp_pj_id}
```

+ クラスタを作成します
  + Autopilot mode のコマンド `create-auto`

```
gcloud beta container clusters create-auto ${_common}-clt \
  --region ${_region} \
  --release-channel "rapid" \
  --network ${_common}-network \
  --subnetwork ${_common}-subnets \
  --cluster-ipv4-cidr "/17" \
  --services-ipv4-cidr "/22" \
  --project ${_gcp_pj_id}
```

---> ここまででクラスタの作成が完了

## Pod をデプロイしてみる

+ GKE と認証します

```
gcloud beta container clusters get-credentials ${_common}-clt \
  --region ${_region} \
  --project ${_gcp_pj_id}
```

+ GKE 上の Pod を確認します

```
kubectl get pod
```
```
# kubectl get pod
No resources found in default namespace.
```

+ GKE 上に疎通テスト用の pod をデプロイします

```
kubectl run test-pod --image=ubuntu:focal-20210416 --command -- tail -f /dev/null
```

+ 再度、 GKE 上の Pod を確認します

```
kubectl get pod
```
```
### 例

# kubectl get po
NAME       READY   STATUS    RESTARTS   AGE
test-pod   1/1     Running   0          115s
```

+ Pod にログインします

```
kubectl exec -it test-pod /bin/bash
```

+ Pod 内から外部に通信をします

```
export debian_frontend=noninteractive

apt update
apt install -y dnsutils curl

dig google.com
curl www.google.com
```
```
exit
```

---> テスト完了

## autopilot の制約

---> 公式のドキュメントを参照してください

## リソースの削除

+ Pod の削除をします

```
kubectl delete pod test-pod
```

+ クラスタの削除をします

```
gcloud beta container clusters delete ${_common}-clt \
  --region ${_region} \
  --project ${_gcp_pj_id} \
  -q
```

+ ネットワークの削除をします

```
gcloud beta compute firewall-rules delete ${_common}-allow-internal-all \
  --project ${_gcp_pj_id} \
  -q

gcloud beta compute networks subnets delete ${_common}-subnets \
  --region ${_region} \
  --project ${_gcp_pj_id} \
  -q

gcloud beta compute networks delete ${_common}-network \
  --project ${_gcp_pj_id} \
  -q
```
