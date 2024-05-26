# VPC Network


## 概要

TBD

## サブネットの IP レンジについて

```
自動モード VPC ネットワークで自動的に作成されるサブネットの IPv4 範囲を示します。このサブネットの IP 範囲は 10.128.0.0/9 CIDR ブロック内にあります。自動モード VPC ネットワークはリージョンごとに 1 つのサブネットで構築され、新しいリージョンで新しいサブネットを自動的に受信します。10.128.0.0/9 の未使用部分は Google Cloud で今後使用するために予約されています。
```

[公式ドキュメント | 自動モードの IPv4 範囲](https://cloud.google.com/vpc/docs/subnets?hl=en#ip-ranges)


## default VPC Network の削除

```
export _gc_pj_id='Your Google Cloud Project ID'
```
```
gcloud beta compute network
gcloud beta compute firewall-rules delete  default-allow-rdp --project ${_gc_pj_id}
```
