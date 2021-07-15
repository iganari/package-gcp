# feature: sessionAffinity/basic

## 実際にやってみる

## GKE クラスタの作成

詳しくは [Create Public Cluster of Standard mode](../../about-cluster/standard-public-gcloud/) を参照してください

+ GCP と認証します

```
gcloud auth login -q
```

```
### Env

export _common='samplesesafi'
export _gcp_pj_id='Your GCP Project ID'
export _region='asia-northeast1'
export _sub_network_range='10.146.0.0/20'
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
  + Standard mode のコマンド
    + `create`

```
gcloud beta container clusters create ${_common}-clt \
  --region ${_region} \
  --release-channel "rapid" \
  --enable-ip-alias \
  --network ${_common}-network \
  --subnetwork ${_common}-subnets \
  --cluster-ipv4-cidr "/17" \
  --services-ipv4-cidr "/22" \
  --num-nodes 1 \
  --project ${_gcp_pj_id}
```

---> ここまででクラスタの作成が完了

## リソースのデプロイ

+ GKE と認証します

```
gcloud beta container clusters get-credentials ${_common}-clt \
  --region ${_region} \
  --project ${_gcp_pj_id}
```

+ マニフェストを用いてデプロイ

```
kubectl apply -f main.yaml
```






---> 検証中 :fire:












```
# kubectl get ingress
NAME               CLASS    HOSTS   ADDRESS          PORTS   AGE
samplesesafi-igr   <none>   *       34.149.220.228   80      157m
```

```

```


## リソースの削除


+ Pod の削除をします

```
kubectl delete -f main.yaml
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
```
```
gcloud beta compute networks subnets delete ${_common}-subnets \
  --region ${_region} \
  --project ${_gcp_pj_id} \
  -q
```
```
gcloud beta compute networks delete ${_common}-network \
  --project ${_gcp_pj_id} \
  -q
```
