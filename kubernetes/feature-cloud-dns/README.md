# Cloud DNS との連携

## 概要

[GKE 向け Cloud DNS の使用](https://cloud.google.com/kubernetes-engine/docs/how-to/cloud-dns)

Cloud DNS で Pod と Service の DNS 解決を行うことが出来る

Pod と Service の DNS レコードは、Service の `ClusterIP`, `Headless`, `Externalname ` 向けに Cloud DNS に自動でプロビジョニングされる

### :warning: 注意

kube-dns で使っていた `svc.cluster.local` は使えなくなる

### アーキテクチャ

![](https://cloud.google.com/kubernetes-engine/images/gke-cloud-dns-architecture.svg)

## やってみる

以下の 3 種類がある

### クラスタ スコープ DNS

[Cluster scope DNS をやってみる](./cluster-scope-dns)

kube-dns が Cloud DNS になっただけ

```
Cluster scope DNS
https://cloud.google.com/kubernetes-engine/docs/how-to/cloud-dns#cluster_scope_dns
```

![](https://cloud.google.com/kubernetes-engine/images/gke-cloud-dns-local-scope.svg)

### VPC スコープ DNS

[VPC scope DNS](./vpc-scope-dns)

GKE クラスタが 2 個で試すことが出来る

メリットは異なる GKE クラスタで、同じ名前が使える

```
VPC scope DNS
https://cloud.google.com/kubernetes-engine/docs/how-to/cloud-dns#vpc_scope_dns
```

![](https://cloud.google.com/kubernetes-engine/images/gke-cloud-dns-vpc-scope.svg)

### 共有 VPC で Cloud DNS

GCP Project が 2 個、GKE クラスタが 2 個で試すことが出来る

Using Cloud DNS with Shared VPC
