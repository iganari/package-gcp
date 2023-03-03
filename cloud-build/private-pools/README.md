# Private Pool

## 概要

Cloud Build 上で Apache Benchmark を実行するサンプル

https://cloud.google.com/build/docs/private-pools/private-pools-overview?hl=en

## 構築


+ GCP に認証をします

```
gcloud auth login --no-launch-browser
```

+ 環境変数を入れておく

```
export _gcp_pj_id='Your GCP Project ID'

export _common='cb-pri'
export _region='asia-northeast1'
export _zone='asia-northeast1-b'
export _sub_network_range='172.16.0.0/12'

export _my_ip='Your Home IP Address'
export _other_ip='Your other IP Address'
```

+ VPC Network の作成

```
gcloud beta compute networks create ${_common}-network \
  --subnet-mode=custom \
  --project ${_gcp_pj_id}
```

+ サブネットの作成

```
gcloud beta compute networks subnets create ${_common}-subnets \
  --network ${_common}-network \
  --region ${_region} \
  --range ${_sub_network_range} \
  --enable-private-ip-google-access \
  --project ${_gcp_pj_id}
````
