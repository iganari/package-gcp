# Cluster について

## Cluster の種類

VPC-native cluster と ルートベース クラスタ があり、VPC-native cluster が推奨 [2021/05時点]

## Cluster の mode

+ Standard
  + Kubernetes cluster with node configuration flexibility and pay-per-node.
+ Autopilot
  + Optimized Kubernetes cluster with a hands-off experience and pay-per-pod.

`Standard` と `Autopilot` はともに `Public cluster` `Private cluster` を作れる

作成方法リンク | Public cluster | Private cluster
:- | :- | :-
Standard mode | [gcloud](./standard-public-gcloud/README.md), [terraform] | [gcloud](./standard-private-gcloud/README.md), [terraform]
Autopilot mode | [gcloud](./autopilot-public-gcloud/README.md), [terraform] | [gcloud](./autopilot-private-gcloud/README.md), [terraform]

+ ルートベース クラスタ
  + 別途記載 

## Private Cluster

Private Cluster を使用する際は Cloud NAT を用いて、インターネットへの送信接続を可能にする必要がある

詳細な設定方法は以下の公式ドキュメントを参照

```
Cloud NAT | Example GKE setup
https://cloud.google.com/nat/docs/gke-example?hl=en
```

## 用語

+ Master
  + Kubernetes でいうと control plane
+ Node Pool
  + Kubernetes でいうと worker node

## 公式 URL

+ [Google Kubernetes Engine （GKE） クラスタ、ノード、GKE API リクエストの割り当てと上限](https://cloud.google.com/kubernetes-engine/quotas)

## 参考 URL

+ [medium | 完全マネージドな k8s ! GKE Autopilot を解説する](https://medium.com/google-cloud-jp/gke-autopilot-87f8458ccf74)
