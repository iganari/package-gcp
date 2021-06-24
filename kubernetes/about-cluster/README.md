# Cluster について

## Clusterの種類

VPC-native cluster と ルートベース クラスタ があり、VPC-native cluster が推奨 [2021/05時点]

+ VPC-native cluster
  + [gcloud](./basic-vpcnative-gcloud/README.md)
  + [WIP] Terraform
  + [WIP] Ansible
+ ルートベース クラスタ
  + [WIP] gcloud
  + [WIP] Terraform
  + [WIP] Ansible

+ 一般公開クラスタ
+ 限定公開クラスタ

## cluster

+ Standard
  + Kubernetes cluster with node configuration flexibility and pay-per-node.
+ Autopilot
  + Optimized Kubernetes cluster with a hands-off experience and pay-per-pod.

`Standard` と `Autopilot` はともに `Public cluster` `Private cluster` を作れる


作成方法リンク | Public cluster | Private cluster
:- | :- | :-
Standard mode | [gcloud](./basic-vpcnative-gcloud/README.md), [terraform] | [gcloud], [terraform]
Autopilot mode | [gcloud], [terraform] | [gcloud](./autopilot-private-gcloud/README.md), [terraform]



+ ルートベース クラスタ
  + 別途記載 
