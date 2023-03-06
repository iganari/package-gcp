# Private Pool

## 概要

Cloud Build 上で Apache Benchmark を実行するサンプル

+ Overview
  + https://cloud.google.com/build/docs/private-pools/private-pools-overview?hl=en
+ Set up
  + https://cloud.google.com/build/docs/private-pools/set-up-private-pool-to-use-in-vpc-network?hl=en

## ネットワーク構成図

![](https://cloud.google.com/build/images/private-pool.png)


## 構築

ここからは https://cloud.google.com/build/docs/private-pools/set-up-private-pool-to-use-in-vpc-network?hl=en

+ GCP に認証をします

```
gcloud auth login --no-launch-browser
```

+ 環境変数を入れておく

```
export _gcp_pj_id='Your GCP Project ID'

export _common='cb-pri'
export _range_name='pri-pool-addr'

export _region='asia-northeast1'
# export _zone='asia-northeast1-b'
# export _sub_network_range='172.16.0.0/12'
# export _my_ip='Your Home IP Address'
# export _other_ip='Your other IP Address'



export _pri_pool_vm_type='e2-medium'
export _pri_pool_vm_size='100'
```

+ Service Networking APIs の有効化

```
gcloud beta services enable cloudbuild.googleapis.com servicenetworking.googleapis.com --project ${_gcp_pj_id}
```

+ VPC Network の作成

```
gcloud beta compute networks create ${_common}-network \
  --subnet-mode=custom \
  --project ${_gcp_pj_id}
```

+ Cloud Build ビルダーが使用する IP レンジを予約する
  + アドレスは指定せずに自動で割り振ってもらうのが楽( `--addresses` が無い理由 )

```
gcloud beta compute addresses create ${_range_name} \
  --global \
  --purpose=VPC_PEERING \
  --prefix-length=16 \
  --description="for Private Pool for Cloud Build" \
  --network ${_common}-network \
  --project ${_gcp_pj_id}
```

+ ペアリング

```
gcloud beta services vpc-peerings connect \
  --service=servicenetworking.googleapis.com \
  --ranges ${_range_name} \
  --network ${_common}-network \
  --project ${_gcp_pj_id}
```

ここからは https://cloud.google.com/build/docs/private-pools/create-manage-private-pools

+ Creating a new private pool

```
gcloud beta builds worker-pools create ${_common}-pool \
  --region=${_region} \
  --peered-network=projects/${_gcp_pj_id}/global/networks/${_common}-network \
  --worker-machine-type=${_pri_pool_vm_type} \
  --worker-disk-size=${_pri_pool_vm_size} \
  --no-public-egress \
  --project=${_gcp_pj_id}
```

ここまで

ここから non doc

+ Cloud NAT で使用する IP Address の予約

```
gcloud beta compute addresses create ${_common}-nat-ip \
  --region ${_region} \
  --project ${_gcp_pj_id}
```

+ Cloud NAT で使用する Cloud Router を作成

```
gcloud beta compute routers create ${_common}-nat-router \
  --network ${_common}-network \
  --region ${_region} \
  --project ${_gcp_pj_id}
```
+ Cloud NAT の作成

```
gcloud beta compute routers nats create ${_common}-nat \
  --router-region ${_region} \
  --router ${_common}-nat-router \
  --nat-all-subnet-ip-ranges \
  --nat-external-ip-pool ${_common}-nat-ip \
  --project ${_gcp_pj_id}
```

## GSC

```
gsutil mb -p ${_gcp_pj_id} -c STANDARD -l ${_region} -b on gs://${_gcp_pj_id}-${_common}-logs
```

作成後、手動で ACLs に変換する


## Service Accunt

+ Create SA

```
gcloud beta iam service-accounts create ${_common}-sa \
  --description="for Private Pool for Cloud Build" \
  --display-name=${_common}-sa \
  --project ${_gcp_pj_id}
```



+ WorkerPool User


```
gcloud projects add-iam-policy-binding ${_gcp_pj_id} \
  --member=serviceAccount:${_common}-sa@${_gcp_pj_id}.iam.gserviceaccount.com \
  --role=roles/cloudbuild.workerPoolUser \
  --project ${_gcp_pj_id}
```

+ GCS


```
gsutil acl ch -u ${_common}-sa@${_gcp_pj_id}.iam.gserviceaccount.com:W gs://${_gcp_pj_id}-${_common}-logs
```

## clud builkd trigger

```
ping -c 5 8.8.8.8
traceroute www.google.com
```

https://cloud.google.com/build/docs/manually-build-code-source-repos

```
WIP


export _github_remo


gcloud beta builds triggers create manual \
  --region ${_region} \
  --name=TRIGGER_NAME \
  --repo=REPO_NAME \
  --repo-type=REPO_TYPE \
  --branch-pattern=BRANCH_PATTERN \
  --build-config=BUILD_CONFIG_FILE \
  --service-account ${_common}-sa@${_gcp_pj_id}.iam.gserviceaccount.com \
  --project ${_gcp_pj_id}
```


## hoge

+ サブネットの作成

```
gcloud beta compute networks subnets create ${_common}-subnets \
  --network ${_common}-network \
  --region ${_region} \
  --range ${_sub_network_range} \
  --enable-private-ip-google-access \
  --project ${_gcp_pj_id}
````
