# Quick Start

## やってみる

```
Configure Cloud IDS
https://cloud.google.com/intrusion-detection-system/docs/configuring-ids
```

## 準備

+ API の有効化

```
gcloud beta services enable ids.googleapis.com --project ${_gcp_pj_id}


gcloud beta services enable servicenetworking.googleapis.com --project ${_gcp_pj_id}
```

## 適用するネットワーク

`Private Google Access` を有効にしている Subnets が必要

## Create Instance

---> 参考 [外部 IP アドレスがついていない VM instance](https://github.com/iganari/package-gcp/tree/main/compute/instances/no-external-ip)

+ Setting env

```
export _gcp_pj_id='Your GCP Project ID'

export _common='cloudids-test'
export _region='asia-northeast1'
export _sub_network_range='10.146.0.0/20'
export _reserved_range='192.168.0.0'
export _reserved_range_prefix='16'
```

+ VPC Network の作成

```
gcloud beta compute networks create ${_common}-network \
  --subnet-mode=custom \
  --project ${_gcp_pj_id}
```

+ Subnet の作成

```
gcloud beta compute networks subnets create ${_common}-subnets \
  --network ${_common}-network \
  --region ${_region} \
  --range ${_sub_network_range} \
  --enable-private-ip-google-access \
  --project ${_gcp_pj_id}
```

```
gcloud beta compute addresses create ${_common}-pricon \
  --global \
  --network ${_common}-network \
  --purpose VPC_PEERING \
  --addresses ${_reserved_range} \
  --prefix-length ${_reserved_range_prefix} \
  --project ${_gcp_pj_id}
```

```
gcloud beta services vpc-peerings connect \
  --service servicenetworking.googleapis.com \
  --ranges ${_common}-pricon \
  --network ${_common}-network \
  --project ${_gcp_pj_id}
```


severity = ( `INFORMATIONAL` | `LOW` | `MEDIUM` | `HIGH` | `CRITICAL` )

```
export _severity='LOW'
```
```
gcloud beta ids endpoints create ${_common}-a \
  --network ${_common}-network \
  --zone ${_region}-a \
  --severity ${_severity} \
  --project ${_gcp_pj_id}
```


---> このコマンドを実行後、処理が終わらない…