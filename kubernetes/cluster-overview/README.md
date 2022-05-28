# Cluster について

## Cluster の種類

VPC-native cluster と ルートベース クラスタ があり、VPC-native cluster が推奨 [2021/05時点]

## Cluster の 2 つの mode

### 概要

```
Types of clusters
https://cloud.google.com/kubernetes-engine/docs/concepts/types-of-clusters
```

+ Standard mode
  + Kubernetes cluster with node configuration flexibility and pay-per-node.
+ Autopilot mode
  + Optimized Kubernetes cluster with a hands-off experience and pay-per-pod.

`Standard` と `Autopilot` はともに `Public cluster` `Private cluster` を作れる

作成方法リンク | Public cluster | Private cluster
:- | :- | :-
Standard mode | [gcloud](./standard-public-gcloud/README.md), [terraform] | [gcloud](./standard-private-gcloud/README.md), [terraform]
Autopilot mode | [gcloud](./autopilot-public-gcloud/README.md), [terraform] | [gcloud](./autopilot-private-gcloud/README.md), [terraform]

+ ルートベース クラスタ
  + 別途記載

### [:fire: WIP :fire:] Standard mode と Autopilot mode の違い

```
Autopilot overview | Comparing Autopilot and Standard modes
https://cloud.google.com/kubernetes-engine/docs/concepts/autopilot-overview#comparison
```
```
Autopilot によるワークロードの制限
https://cloud.google.com/kubernetes-engine/docs/concepts/autopilot-overview#limits
```

WIP


## Private Cluster

Private Cluster を使用する際は Cloud NAT を用いて、インターネットへの送信接続を可能にする必要がある

詳細な設定方法は以下の公式ドキュメントを参照

[Cloud NAT | Example GKE setup](https://cloud.google.com/nat/docs/gke-example)

## Price について

クラスターの管理費として $0.10/Hour のコストが掛かる。これは Node のコストとは別に `管理費` としてかかってくるので、 GKE クラスターが起動している時間分課金される

[Google Kubernetes Engine pricing](https://cloud.google.com/kubernetes-engine/pricing)

## コスト削減

+ [Node Pool に Preemptible VM を使う](https://cloud.google.com/kubernetes-engine/docs/how-to/preemptible-vms)

+ [Autopilot で Spot Pod を使う](https://cloud.google.com/kubernetes-engine/docs/how-to/autopilot-spot-pods)


## 用語

+ Master
  + Kubernetes でいうと control plane
+ Node Pool
  + Kubernetes でいうと worker node

## 公式 URL

+ [Google Kubernetes Engine （GKE） クラスタ、ノード、GKE API リクエストの割り当てと上限](https://cloud.google.com/kubernetes-engine/quotas)

## 参考 URL

+ [medium | 完全マネージドな k8s ! GKE Autopilot を解説する](https://medium.com/google-cloud-jp/gke-autopilot-87f8458ccf74)
