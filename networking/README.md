# VPC Network

## 概要

TBD

## API の有効化

- VPC Network は Compute Engine の API を有効化すると使える様になる

```
gcloud beta services enable compute.googleapis.com --project ${_gc_pj_id}
```

## URL

VPC 設計のためのおすすめの方法とリファレンス アーキテクチャ
https://cloud.google.com/architecture/best-practices-vpc-design?hl=ja

## default の削除

デフォルトの VPC Network および Firewall Rule はセキュリティ的に良く無いので、はじめに削除しておく (組織ポリシーで禁止も可能)

<details>
<summary>削除コマンド</summary>

```
export _gc_pj_id='Your Google Cloud Project ID'
```

- default の Firewall Rule の削除

```
gcloud beta compute firewall-rules delete default-allow-icmp --project ${_gc_pj_id} --quiet
gcloud beta compute firewall-rules delete default-allow-internal --project ${_gc_pj_id} --quiet
gcloud beta compute firewall-rules delete default-allow-rdp --project ${_gc_pj_id} --quiet
gcloud beta compute firewall-rules delete default-allow-ssh --project ${_gc_pj_id} --quiet
```

- defult の VPC Network の削除

```
gcloud beta compute networks delete default --project ${_gc_pj_id} --quiet
```

</details>
