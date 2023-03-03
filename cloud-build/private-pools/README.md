# Private Pool

## 概要

Cloud Build 上で Apache Benchmark を実行するサンプル

+ Overview
  + https://cloud.google.com/build/docs/private-pools/private-pools-overview?hl=en
+ Set up
  + https://cloud.google.com/build/docs/private-pools/set-up-private-pool-to-use-in-vpc-network?hl=en

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
export _zone='asia-northeast1-b'


 

export _sub_network_range='172.16.0.0/12'

export _my_ip='Your Home IP Address'
export _other_ip='Your other IP Address'
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
