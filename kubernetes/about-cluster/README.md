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

## 用語

+ Master
  + Kubernetes でいうと control plane
+ Node Pool
  + Kubernetes でいうと worker node