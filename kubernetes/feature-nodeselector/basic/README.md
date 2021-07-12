# feature: nodeSelector/basic

## 概要

Apache と nginx の Pod を使って、簡単な nodeSelector の挙動確認をします

## GKE クラスタの作成

詳しくは [Create Public Cluster of Standard mode](../../about-cluster/standard-public-gcloud/) を参照してください

+ GCP と認証します

```
gcloud auth login -q
```

```
### Env

export _common='samplenodeselect'
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

+ Node Pool を 2 個 追加します
  + apache 用と nginx 用 

```
gcloud beta container node-pools create "${_common}-add-pool-apache" \
  --cluster ${_common}-clt \
  --region ${_region} \
  --machine-type "n1-standard-1" \
  --image-type "COS_CONTAINERD" \
  --preemptible \
  --num-nodes 1 \
  --enable-autoscaling \
  --min-nodes 1 \
  --max-nodes 5 \
  --enable-autoupgrade \
  --enable-autorepair \
  --max-surge-upgrade 1 \
  --max-unavailable-upgrade 0 \
  --project ${_gcp_pj_id}
```
```
gcloud beta container node-pools create "${_common}-add-pool-nginx" \
  --cluster ${_common}-clt \
  --region ${_region} \
  --machine-type "n1-standard-1" \
  --image-type "COS_CONTAINERD" \
  --preemptible \
  --num-nodes 1 \
  --enable-autoscaling \
  --min-nodes 1 \
  --max-nodes 5 \
  --enable-autoupgrade \
  --enable-autorepair \
  --max-surge-upgrade 1 \
  --max-unavailable-upgrade 0 \
  --project ${_gcp_pj_id}
```

+ デフォルトで作られた node pool を削除します

```
gcloud beta container node-pools delete default-pool \
  --cluster ${_common}-clt \
  --region ${_region} \
  --project ${_gcp_pj_id} \
  -q
```

---> ここまででクラスタの作成が完了

## node pool を調べる

+ node pool を調べる

```
gcloud beta container node-pools list \
  --cluster ${_common}-clt \
  --region ${_region} \
  --project ${_gcp_pj_id}
```
```
### 例

# gcloud beta container node-pools list --cluster ${_common}-clt \
>   --region ${_region} \
>   --project ${_gcp_pj_id}
NAME                              MACHINE_TYPE   DISK_SIZE_GB  NODE_VERSION
samplenodeselect-add-pool-apache  n1-standard-1  100           1.20.6-gke.1400
samplenodeselect-add-pool-nginx   n1-standard-1  100           1.20.6-gke.1400
```

---> node pool が 2 個あることが分かります

+ 実際の node を調べます

```
kubectl get node
```
```
### 例

# kubectl get node
NAME                                                  STATUS   ROLES    AGE     VERSION
gke-samplenodeselect-samplenodeselect-226da9e6-59r6   Ready    <none>   34m     v1.20.6-gke.1400
gke-samplenodeselect-samplenodeselect-42ceba68-2l9q   Ready    <none>   34m     v1.20.6-gke.1400
gke-samplenodeselect-samplenodeselect-6952b6ad-h3tv   Ready    <none>   6m56s   v1.20.6-gke.1400
gke-samplenodeselect-samplenodeselect-a834d573-fz0s   Ready    <none>   6m42s   v1.20.6-gke.1400
gke-samplenodeselect-samplenodeselect-d7d7c82f-gvp5   Ready    <none>   34m     v1.20.6-gke.1400
gke-samplenodeselect-samplenodeselect-fe7f7eda-j3cw   Ready    <none>   6m55s   v1.20.6-gke.1400
```

---> node が 6 個あるのが分かりますが、 node pool との関係性が分かりません

+ node pool に紐づいている Instance Group を調べます

```
### apache 用
gcloud beta container node-pools describe ${_common}-add-pool-apache\
  --cluster ${_common}-clt \
  --region ${_region} \
  --project ${_gcp_pj_id} \
  --format json \
  | jq .instanceGroupUrls[]
```
```
### 例 

# gcloud beta container node-pools describe ${_common}-add-pool-apache\
>   --cluster ${_common}-clt \
>   --region ${_region} \
>   --project ${_gcp_pj_id} \
>   --format json \
>   | jq .instanceGroupUrls[]
"https://www.googleapis.com/compute/v1/projects/{your_gcp_pj_id}/zones/asia-northeast1-b/instanceGroupManagers/gke-samplenodeselect-samplenodeselect-42ceba68-grp"
"https://www.googleapis.com/compute/v1/projects/{your_gcp_pj_id}/zones/asia-northeast1-c/instanceGroupManagers/gke-samplenodeselect-samplenodeselect-d7d7c82f-grp"
"https://www.googleapis.com/compute/v1/projects/{your_gcp_pj_id}/zones/asia-northeast1-a/instanceGroupManagers/gke-samplenodeselect-samplenodeselect-226da9e6-grp"
```
```
### nginx 用

gcloud beta container node-pools describe ${_common}-add-pool-nginx\
  --cluster ${_common}-clt \
  --region ${_region} \
  --project ${_gcp_pj_id} \
  --format json \
  | jq .instanceGroupUrls[]
```
```
### 例
# gcloud beta container node-pools describe ${_common}-add-pool-nginx\
>   --cluster ${_common}-clt \
>   --region ${_region} \
>   --project ${_gcp_pj_id} \
>   --format json \
>   | jq .instanceGroupUrls[]
"https://www.googleapis.com/compute/v1/projects/{your_gcp_pj_id}/zones/asia-northeast1-b/instanceGroupManagers/gke-samplenodeselect-samplenodeselect-6952b6ad-grp"
"https://www.googleapis.com/compute/v1/projects/{your_gcp_pj_id}/zones/asia-northeast1-c/instanceGroupManagers/gke-samplenodeselect-samplenodeselect-fe7f7eda-grp"
"https://www.googleapis.com/compute/v1/projects/{your_gcp_pj_id}/zones/asia-northeast1-a/instanceGroupManagers/gke-samplenodeselect-samplenodeselect-a834d573-grp"
```

---> Instance Group が分かりました

+ Instance Group に入っている VM Instance を調べます

```
gcloud beta compute instance-groups list-instances {Instance Group Name} --zone {Instance Group Zone} --project ${_gcp_pj_id}
```

+ ここまでのコマンドを使い、 node と node pool の関係性を調べます

```
### Apache 用

export _node_pool_name=${_common}-add-pool-apache

for i in $(gcloud beta container node-pools describe ${_node_pool_name} --cluster ${_common}-clt --region ${_region} --project ${_gcp_pj_id} --format json | jq .instanceGroupUrls[] -r)
  do
    export _int_grp_zone=$(echo $i | awk -F\/ '{print $9}')
    export _int_grp_name=$(echo $i | awk -F\/ '{print $11}')
    export _int_name=$(gcloud beta compute instance-groups list-instances ${_int_grp_name} --zone ${_int_grp_zone} --project ${_gcp_pj_id} | grep ${_int_grp_zone} | awk '{print $1}')

    echo "[node name: ${_int_name}] in [node pool: ${_node_pool_name}]"
  done
```
```
### 出力例

[node name: gke-samplenodeselect-samplenodeselect-42ceba68-2l9q] in [node pool: samplenodeselect-add-pool-apache]
[node name: gke-samplenodeselect-samplenodeselect-d7d7c82f-gvp5] in [node pool: samplenodeselect-add-pool-apache]
[node name: gke-samplenodeselect-samplenodeselect-226da9e6-59r6] in [node pool: samplenodeselect-add-pool-apache]
```
```
### nginx 用

export _node_pool_name=${_common}-add-pool-nginx

for i in $(gcloud beta container node-pools describe ${_node_pool_name} --cluster ${_common}-clt --region ${_region} --project ${_gcp_pj_id} --format json | jq .instanceGroupUrls[] -r)
  do
    export _int_grp_zone=$(echo $i | awk -F\/ '{print $9}')
    export _int_grp_name=$(echo $i | awk -F\/ '{print $11}')
    export _int_name=$(gcloud beta compute instance-groups list-instances ${_int_grp_name} --zone ${_int_grp_zone} --project ${_gcp_pj_id} | grep ${_int_grp_zone} | awk '{print $1}')

    echo "[node name: ${_int_name}] in [node pool: ${_node_pool_name}]"
  done
```
```
### 出力例

[node name: gke-samplenodeselect-samplenodeselect-6952b6ad-h3tv] in [node pool: samplenodeselect-add-pool-nginx]
[node name: gke-samplenodeselect-samplenodeselect-fe7f7eda-j3cw] in [node pool: samplenodeselect-add-pool-nginx]
[node name: gke-samplenodeselect-samplenodeselect-a834d573-fz0s] in [node pool: samplenodeselect-add-pool-nginx]
```

---> node と node pool の関係性が分かりました :)

## Pod をデプロイする

+ マニフェストを作成します

```
cat << __EOF__ > main.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache
spec:
  replicas: 2
  selector:
    matchLabels:
      app: apache
  template:
    metadata:
      labels:
        app: apache
    spec:
      containers:
      - name: apache
        image: httpd:2.4.48-buster
        imagePullPolicy: IfNotPresent
      nodeSelector:
        cloud.google.com/gke-nodepool: ${_common}-add-pool-apache
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.21.1-alpine
        imagePullPolicy: IfNotPresent
      nodeSelector:
        cloud.google.com/gke-nodepool: ${_common}-add-pool-nginx
__EOF__
```

+ デプロイします

```
kubectl apply -f main.yaml
```

+ Pod がどの node 上にあるか確認します

```
kubectl get pod -o wide
```

```
# kubectl get pod -o wide
NAME                      READY   STATUS    RESTARTS   AGE   IP          NODE                                                  NOMINATED NODE   READINESS GATES
apache-7bd94974dc-4gsmn   1/1     Running   0          16m   10.88.5.3   gke-samplenodeselect-samplenodeselect-226da9e6-59r6   <none>           <none>
apache-7bd94974dc-jwbgz   1/1     Running   0          16m   10.88.3.4   gke-samplenodeselect-samplenodeselect-42ceba68-2l9q   <none>           <none>
nginx-959bc7f44-ghbs9     1/1     Running   0          36s   10.88.7.4   gke-samplenodeselect-samplenodeselect-fe7f7eda-j3cw   <none>           <none>
nginx-959bc7f44-vh9j9     1/1     Running   0          27s   10.88.8.4   gke-samplenodeselect-samplenodeselect-a834d573-fz0s   <none>           <none>
```

+ [再掲] node と node pool の関係性

```
### apache 用

[node name: gke-samplenodeselect-samplenodeselect-42ceba68-2l9q] in [node pool: samplenodeselect-add-pool-apache]
[node name: gke-samplenodeselect-samplenodeselect-d7d7c82f-gvp5] in [node pool: samplenodeselect-add-pool-apache]
[node name: gke-samplenodeselect-samplenodeselect-226da9e6-59r6] in [node pool: samplenodeselect-add-pool-apache]
```
```
### nginx 用

[node name: gke-samplenodeselect-samplenodeselect-6952b6ad-h3tv] in [node pool: samplenodeselect-add-pool-nginx]
[node name: gke-samplenodeselect-samplenodeselect-fe7f7eda-j3cw] in [node pool: samplenodeselect-add-pool-nginx]
[node name: gke-samplenodeselect-samplenodeselect-a834d573-fz0s] in [node pool: samplenodeselect-add-pool-nginx]
```

---> 上記より、 nodeSelector を通じて、 node の指定が出来ていることが確認できました :)

## 再現確認 1

一度 pod をすべて削除し、同じマニフェストで再デプロイをして、挙動を確認します

+ 削除とデプロイ

```
kubectl delete -f main.yaml
kubectl apply -f main.yaml
```

+ Pod がどの node 上にあるか確認します

```
# kubectl get pod -o wide
NAME                      READY   STATUS    RESTARTS   AGE   IP          NODE                                                  NOMINATED NODE   READINESS GATES
apache-7bd94974dc-849pd   1/1     Running   0          49s   10.88.3.6   gke-samplenodeselect-samplenodeselect-42ceba68-2l9q   <none>           <none>
apache-7bd94974dc-9dppf   1/1     Running   0          49s   10.88.5.5   gke-samplenodeselect-samplenodeselect-226da9e6-59r6   <none>           <none>
nginx-959bc7f44-r2hbq     1/1     Running   0          49s   10.88.8.5   gke-samplenodeselect-samplenodeselect-a834d573-fz0s   <none>           <none>
nginx-959bc7f44-ssg8f     1/1     Running   0          49s   10.88.7.5   gke-samplenodeselect-samplenodeselect-fe7f7eda-j3cw   <none>           <none>
```

---> 上記より、同じマニフェストを使用して再現性が確認できました :)

## 再現確認 2

一度 pod をすべて削除し、マニフェストを修正して再デプロイをし、挙動を確認します

+ 削除

```
kubectl delete -f main.yaml
```

+ apache と nginx の nodeSelector を入れ替える

```
sed -ie "s/${_common}-add-pool-nginx/${_common}-add-pool-tmp/g" main.yaml
sed -ie "s/${_common}-add-pool-apache/${_common}-add-pool-nginx/g" main.yaml
sed -ie "s/${_common}-add-pool-tmp/${_common}-add-pool-apache/g" main.yaml
```
```
kubectl apply -f main.yaml
```

+ Pod がどの node 上にあるか確認します

```
# kubectl get pod -o wide
NAME                      READY   STATUS    RESTARTS   AGE   IP          NODE                                                  NOMINATED NODE   READINESS GATES
apache-5d547dc6f5-8zf9j   1/1     Running   0          65s   10.88.7.6   gke-samplenodeselect-samplenodeselect-fe7f7eda-j3cw   <none>           <none>
apache-5d547dc6f5-j5dbg   1/1     Running   0          65s   10.88.8.6   gke-samplenodeselect-samplenodeselect-a834d573-fz0s   <none>           <none>
nginx-85bdd5d88b-h69kk    1/1     Running   0          65s   10.88.3.7   gke-samplenodeselect-samplenodeselect-42ceba68-2l9q   <none>           <none>
nginx-85bdd5d88b-kj7jg    1/1     Running   0          65s   10.88.5.6   gke-samplenodeselect-samplenodeselect-226da9e6-59r6   <none>           <none>
```

---> 上記より、nodeSelector を変更してデプロイしても再現性が確認できました :)

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
