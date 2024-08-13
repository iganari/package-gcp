# VPC Network


## 概要

TBD

## サブネットの IP レンジについて

```
自動モード VPC ネットワークで自動的に作成されるサブネットの IPv4 範囲を示します。このサブネットの IP 範囲は 10.128.0.0/9 CIDR ブロック内にあります。自動モード VPC ネットワークはリージョンごとに 1 つのサブネットで構築され、新しいリージョンで新しいサブネットを自動的に受信します。10.128.0.0/9 の未使用部分は Google Cloud で今後使用するために予約されています。
```

[公式ドキュメント | 自動モードの IPv4 範囲](https://cloud.google.com/vpc/docs/subnets?hl=en#ip-ranges)

## コマンド

```
### Env

export _gc_pj_id='Your Google Cloud Project ID'

export _common='pkg-gcp'
export _region='asia-northeast1'
export _sub_network_range='10.0.0.0/16'
```

- VPC Network の作成

```
gcloud beta compute networks create ${_common} \
  --subnet-mode=custom \
  --project ${_gc_pj_id}
```

- Subnet の作成

```
gcloud beta compute networks subnets create ${_common}-${_region} \
  --network ${_common} \
  --region ${_region} \
  --range ${_sub_network_range} \
  --enable-private-ip-google-access \
  --project ${_gc_pj_id}
```


## default VPC Network の削除

### Firewall Rule の削除

```
export _gc_pj_id='Your Google Cloud Project ID'
```

+ Firewall Rule の確認

```
gcloud beta compute firewall-rules list --project ${_gc_pj_id} --format=json
```

+ Firewall Rule の削除

```
gcloud beta compute firewall-rules delete default-allow-rdp --project ${_gc_pj_id} --quiet
gcloud beta compute firewall-rules delete default-allow-internal --project ${_gc_pj_id} --quiet
gcloud beta compute firewall-rules delete default-allow-ssh --project ${_gc_pj_id} --quiet
gcloud beta compute firewall-rules delete default-allow-icmp --project ${_gc_pj_id} --quiet
```

+ Firewall Rule の確認

```
gcloud beta compute firewall-rules list --project ${_gc_pj_id} --format=json
```

### default VPC Network の削除

+ VPC Network の確認

```
gcloud beta compute networks list --project ${_gc_pj_id}
```

+ VPC Network の削除

```
gcloud beta compute networks delete default --project ${_gc_pj_id} --quiet
```

+ VPC Network の確認

```
gcloud beta compute networks list --project ${_gc_pj_id}
```








