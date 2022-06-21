# Kubernetes Engine

## 説明

+ GCP 上で Kubernetes を使うためのサンプルを集めています。
  + つまり、 基本的には GKE のサンプルがメインになります。

## 先にインストールしておきたいコマンド

```
gcloud components install beta -q &&\
gcloud components update -q && \
gcloud components install kubectl -q
```


## Cluster

+ [Cluster について](./cluster-overview)
  + [Create Private Cluster of Autopilot mode](./autopilot-private-gcloud)
  + [Create Public Cluster of Autopilot mode](./autopilot-public-gcloud)
  + [Create Private Cluster of Standard mode](./standard-private-gcloud)
  + [Create Public Cluster of Standard mode](./standard-public-gcloud)
  + WIP [Standard mode と Autopilot mode の違いについて]
+ [cluster-version-upgrade](./cluster-version-upgrade)
  + GKE クラスタのアップグレード方法
  + :fire: [WIP] GKE クラスタのバージョンアップの検討事項
    + https://cloud.google.com/kubernetes-engine/docs/best-practices/upgrading-clusters#continuous-strategy
    + https://kubernetes.io/releases/version-skew-policy

## Kind

+ [Cron Jobs](./kind-cronjobs)
+ [Ingress](./kind-ingress)
+ [Managed Certificate](./kind-managedcertificate)
+ [Persistent Volume Claim](./kind-persistentvolumeclaim)
+ [PriorityClass](./kind-priorityclass)
+ [Secret](./kind-secret)
+ [StatefulSet](./kind-statufulset)
+ [Role / RoleBinding / ClusterRole / ClusterRoleBinding](./kind-role-rolebinding)

## Feature

+ [Cloud Armor](./modify-readme-only)
+ [IAP](./feature-iap)
  + Ingress に IAP を付与するやり方 ( 正確には BackendConfig を設定し、 Service に関連付けする )
+ [nodeSelector](./feature-nodeselector)
  + Pod を特定のノードプールに明示的にデプロイする
+ [SSL](./feature-iap)
+ [Workload Identity](./feature-iap)

## Sample

+ [Laravel](./sample-laravel)
+ [WordPress](./sample-wordpress)


## Tips

+ [Optimizing IP address allocation](./xx_flexible-pod-cidr)


## 参考になりそうな URL

```
Best practices for GKE networking
https://cloud.google.com/kubernetes-engine/docs/best-practices/networking
```
```
GKE のアップグレード戦略を改めて確認しよう
https://medium.com/google-cloud-jp/gke-upgrade-strategy-8568f450f9d0
```
```
クラスタのアップグレードに関するベスト プラクティス
https://cloud.google.com/kubernetes-engine/docs/best-practices/upgrading-clusters
```
```
GKE release notes
https://cloud.google.com/kubernetes-engine/docs/release-notes
```
```
クラスタのタイプ
https://cloud.google.com/kubernetes-engine/docs/concepts/types-of-clusters#modes
```
```
GKE Autopilot 入門
https://lp.cloudplatformonline.com/rs/808-GJW-314/images/App_Modernization_OnAir_q3_0728_Session1.pdf
```
```
GKE でマイクロ サービスの構築をする基礎から、高度なトラフィックルーティングと SLO 運用に至るまでの流れを解説
https://www.youtube.com/watch?v=I5Jz6Ay9oBY
```


```
GKE: Concepts of Networking
https://www.youtube.com/watch?v=aVBV4O3h4AY
```
