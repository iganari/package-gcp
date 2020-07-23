# GKE 上に Cloud SQL を使用した WordPress を作成する

## やること

公式 ドキュメントに沿って、WordPress + CloudSQL on GKE をやってみる

+ 公式ドキュメント
  + https://cloud.google.com/kubernetes-engine/docs/tutorials/persistent-disk?hl=ja
+ 使用する GitHub
  + https://github.com/GoogleCloudPlatform/kubernetes-engine-samples/tree/master/wordpress-persistent-disks


## やってみる

+ [GKE を作成する](./README.md#create-gke)
  + [GKE で使用するネットワークの作成](./README.md#create-network)
  + [GKE Cluster の作成](./README.md#cerate-gke-cluster)
+ [CloudSQL を作成する](./README.md#create-cloud-sql)

## GKE を用意しておく

+ WIP
  + GCP Project ID
    + ca-igarashi-corp-renewal
  + GKE Cluster name
    + site-renewal-2021-cluster

## Create GKE

### Create Network

+ GCP authentication.

```
gcloud auth login
```

+ Setting GCP Project on Console.

```
export _pj_id='Your GCP Project ID'
```
```
gcloud config set project ${_pj_id}
```

+ Make VPC network and Subnets

```
export _common='wp-gke-cloudsql'
export _region='asia-northeast1'
```
```
gcloud beta compute networks create ${_common}-network \
  --subnet-mode=custom
```
```
gcloud beta compute networks subnets create ${_common}-subnets \
  --network ${_common}-network \
  --region ${_region} \
  --range 10.140.0.0/20
```

+ Make Firewall Rules

```
gcloud compute firewall-rules create ${_common}-allow-internal \
  --network ${_common}-network \
  --allow tcp:0-65535,udp:0-65535,icmp
```

### Cerate GKE Cluster

+ Create (Zonal) GKE Cluster.

```
gcloud beta container clusters create "${_common}-cluster" \
  --project "${_pj_id}" \
  --zone "${_region}-a"\
  --no-enable-basic-auth \
  --release-channel "regular" \
  --machine-type "n1-standard-1" \
  --image-type "COS" \
  --disk-type "pd-standard" \
  --disk-size "100" \
  --preemptible \
  --num-nodes "3" \
  --enable-stackdriver-kubernetes \
  --enable-ip-alias \
  --network "projects/${_pj_id}/global/networks/${_common}-network" \
  --subnetwork "projects/${_pj_id}/regions/${_region}/subnetworks/${_common}-subnets" \
  --default-max-pods-per-node "110" \
  --enable-autoscaling \
  --min-nodes "0" \
  --max-nodes "3" \
  --no-enable-master-authorized-networks \
  --addons HorizontalPodAutoscaling,HttpLoadBalancing,Istio \
  --istio-config auth=MTLS_PERMISSIVE \
  --enable-autoupgrade \
  --enable-autorepair \
  --max-surge-upgrade 1 \
  --max-unavailable-upgrade 0
```

+ Create and Attach additional Node Pool
  + https://cloud.google.com/kubernetes-engine/docs/how-to/node-pools?hl=en

```
gcloud container node-pools create ${_common}-pool \
  --cluster "${_common}-cluster" \
  --zone "${_region}-a" \
  --preemptible \
  --num-nodes "3" \
  --enable-autoscaling \
  --min-nodes "0" \
  --max-nodes "3" \
  --enable-autoupgrade \
  --enable-autorepair \
  --max-surge-upgrade 2 \
  --max-unavailable-upgrade 1
```

+ Check your Node of GKE.
  + You have Two Node Pools.

```
gcloud container node-pools list \
  --cluster ${_common}-cluster \
  --zone "${_region}-a"
```

+ Delete default Node Pool

```
gcloud container node-pools delete default-pool \
  --cluster "${_common}-cluster" \
  --zone "${_region}-a"
```

+ ReCheck your Node of GKE.
  + You have One Node Pool only!

```
gcloud container node-pools list \
  --cluster ${_common}-cluster \
  --zone "${_region}-a"
```

+ GKE authentication.

```
gcloud container clusters get-credentials ${_common}-cluster \
  --zone "${_region}-a"
```

## Create Cloud SQL

+ Create Cloud SQL instance

```
### 既にある設定
export _common='wp-gke-cloudsql'
export _region='asia-northeast1'

### 新規設定
export _db_instance_type='db-f1-micro' 
```
```
gcloud beta sql instances create ${_common}-instance \
  --database-version=MYSQL_5_7 \
  --tier=${_db_instance_type} \
  --zone=${_region}-a \
  --root-password=password123
```

+ Check Instance

```
gcloud beta sql instances list | grep ${_common}-instance
```

+ Create DB user / password

```
export CLOUD_SQL_USER='wordpress-admin'
export CLOUD_SQL_PASSWORD='hogehoge'

gcloud beta sql users create ${CLOUD_SQL_USER} \
  --instance=${_common}-instance \
  --host="%" \
  --password ${CLOUD_SQL_PASSWORD}
```

+ 環境変数を作っておく
  + あとで入れる

```
export INSTANCE_CONNECTION_NAME=$(gcloud sql instances describe ${_common}-instance --format='value(connectionName)')
echo ${INSTANCE_CONNECTION_NAME}
```

```
+ database の作成
  + コンテナイメージに `wordpress` とベタ書きされているため
  + コンテナに kubectl exec すれば分かる


gcloud beta sql databases 
```


## Create Service Account

+ GKE から Cloud SQL に繋ぐ、Service Account (と Key) を作る

```
export _sa_name=${_common}-gke
echo ${_sa_name}

gcloud beta iam service-accounts create ${_sa_name} --display-name ${_sa_name}
```

+ 作成した Service Account に、 CloudSQL の client 権限を付与します

```
export _sa_email=$(gcloud iam service-accounts list --filter=displayName:${_sa_name} --format='value(email)')
echo ${_sa_email}


gcloud projects add-iam-policy-binding ${_pj_id} \
  --role roles/cloudsql.client \
  --member serviceAccount:${_sa_email}
```

+ Service Account に紐づく Key の作成

```
gcloud iam service-accounts keys create ./serviceAccount-${_sa_name}-key.json \
  --iam-account ${_sa_email}
```

## Create Secret

+ GKE との認証

```
gcloud container clusters get-credentials ${_common}-cluster \
  --zone "${_region}-a"
```

+ K8s のシークレットを 2 個作る

```
kubectl create secret generic cloudsql-db-credentials \
  --from-literal username=${CLOUD_SQL_USER} \
  --from-literal password=${CLOUD_SQL_PASSWORD}
```
```
kubectl create secret generic cloudsql-instance-credentials \
  --from-file ./serviceAccount-${_sa_name}-key.json
```

## Create Kubernetes Resource

+ PV と PVC を作成する
  + https://cloud.google.com/kubernetes-engine/docs/tutorials/persistent-disk?hl=ja#creating-a-pv-and-a-pvc-back-by=persistent-disks

```
k create -f 01_wordpress-volumeclaim.yaml
```

+ 確認

```
k get pvc
```
```
# k get pvc
NAME                    STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
wordpress-volumeclaim   Bound    pvc-31df75a6-11e7-4db1-8ffd-a480cd6a763a   200Gi      RWO            standard       10s
```

+ Cloud SQL for MySQL インスタンスを作成する

```
## 必要な環境変数
echo ${INSTANCE_CONNECTION_NAME}

```

+ サンプルコンフィグからマニフェストを作成する

```
### alpine の場合は下記で envsubst をインストールする
apk --no-cache add gettext

### サンプルコンフィグからマニフェストを作成する
cat 02_wordpress_cloudsql.yaml.template | envsubst > 02_wordpress_cloudsql.yaml
```

+ デプロイ

```
kubectl create -f 02_wordpress_cloudsql.yaml
```

+ 確認

```
watch -n1 kubectl get pod -l app=wordpress 
```

+ Service の作成

```
k create -f 03_wordpress-service.yaml
```

+ 確認
  + `EXTERNAL-IP` が割り当てられることを確認する

```
watch -n1 kubectl get service
```

+ debug
  + Pod の中に複数のコンテナがある場合(今回はCloudSQLのコンテナがサイドカーとしている)

```
k exec -it wordpress-5b95bc6b5c-kbpx8 -c cloudsql-proxy -- /bin/ash
```
```
k exec -it wordpress-5b95bc6b5c-kbpx8 -c wordpress -- /bin/bash
k exec -it wordpress-5b95bc6b5c-kbpx8 -c cloudsql-proxy -- /bin/ash
```

+ Web ブラウザで確認する

```
### EXTERNAL-IP の確認
kubectl get service | grep wordpress | awk '{print $4}'
```
```
### Ex.
# kubectl get service | grep wordpress | awk '{print $4}'
34.85.70.95


---> http://34.85.70.95 にアクセスする
```


## Delete Resource

+ Kubernetes のリソースの削除

```
k delete -f 03_wordpress-service.yaml && \
k delete -f 02_wordpress_cloudsql.yaml && \
k delete -f 01_wordpress-volumeclaim.yaml
```

+ ServiceAccount の削除

```
gcloud beta iam service-accounts delete ${_sa_email} \
  --project "${_pj_id}" -q
```

+ GKE Cluster の削除

```
gcloud beta container clusters delete "${_common}-cluster" \
  --project "${_pj_id}" \
  --zone "${_region}-a" -q
```

+ CloudSQL の削除

```
gcloud beta sql instances delete ${_common}-instance -q
```

+ Firewall Rule の削除

```
gcloud compute firewall-rules delete ${_common}-allow-internal -q
```

+ VPC network と Subnet の削除

```
gcloud beta compute networks subnets delete ${_common}-subnets \
  --region ${_region} -q
```
```
gcloud beta compute networks delete ${_common}-network -q
```

おわり
