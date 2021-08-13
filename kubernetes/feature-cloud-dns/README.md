# Cloud DNS との連携

## 概要

[GKE 向け Cloud DNS の使用](https://cloud.google.com/kubernetes-engine/docs/how-to/cloud-dns)

Cloud DNS で Pod と Service の DNS 解決を行うことが出来る

Pod と Service の DNS レコードは、Service の `ClusterIP`, `Headless`, `Externalname ` 向けに Cloud DNS に自動でプロビジョニングされる

### アーキテクチャ

![](https://cloud.google.com/kubernetes-engine/images/gke-cloud-dns-architecture.svg)

## やってみる

以下の 3 種類がある

### クラスタ スコープ DNS

GKE クラスタが 1 個で試すことが出来る

Cluster scope DNS

### VPC スコープ DNS

GKE クラスタが 2 個で試すことが出来る

VPC scope DNS

### 共有 VPC で Cloud DNS

GCP Project が 2 個、GKE クラスタが 2 個で試すことが出来る

Using Cloud DNS with Shared VPC

