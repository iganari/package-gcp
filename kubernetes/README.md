# Google Kubernetes Engine

## 説明

+ GCP 上で Kubernetes を使うためのサンプルを集めています。
  + つまり、 基本的には GKE のサンプルがメインになります。

## 先にインストールしておきたいコマンド

```
gcloud components install beta -q && \
gcloud components update -q && \
gcloud components install kubectl -q
```

## インストール方法


### Linux on GCE の場合

+ https://cloud.google.com/sdk/docs/install#deb
+ https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke?hl=en

+ 必要なパッケージのインストール

```
sudo apt-get install -y apt-transport-https ca-certificates gnupg
```

+ apt のリポジトリを追加

```
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
```

+ apt 用の Google Cloud public key を追加

```
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
```

+ gcloud CLI のアップデート

```
sudo apt-get update && sudo apt-get install -y google-cloud-cli
```

+ GKE 用の認証プラグインをインストール

```
sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin
```

## [Cluster について](./cluster-overview)

+ mode と { Private or Public }
  + [Create Private Cluster of Autopilot mode](./autopilot-private-gcloud)
  + [Create Public Cluster of Autopilot mode](./autopilot-public-gcloud)
  + [Create Private Cluster of Standard mode](./standard-private-gcloud)
  + [Create Public Cluster of Standard mode](./standard-public-gcloud)
  + WIP [Standard mode と Autopilot mode の違いについて]

+ GKE クラスタのアップグレード方法
  + [cluster-version-upgrade](./cluster-version-upgrade)
    + :fire: [WIP] GKE クラスタのバージョンアップの検討事項
    + https://kubernetes.io/releases/version-skew-policy
+ GKE クラスタのアップグレード戦略
  + [継続的なアップグレード戦略を作成する](https://cloud.google.com/kubernetes-engine/docs/best-practices/upgrading-clusters#continuous-strategy)
  + <WIP> [Zenn | GKE クラスタのアップグレード戦略を考える]()

## Kind について

+ [Cron Jobs](./kind-cronjobs)
+ [Ingress](./kind-ingress)
+ [Managed Certificate](./kind-managedcertificate)
+ [Persistent Volume Claim](./kind-persistentvolumeclaim)
+ [PriorityClass](./kind-priorityclass)
+ [Secret](./kind-secret)
+ [StatefulSet](./kind-statufulset)
+ [Role / RoleBinding / ClusterRole / ClusterRoleBinding](./kind-role-rolebinding)
  + [Google Groups for RBAC を設定してみる](./kind-role-rolebinding/google-groups-rbac/)

## 周辺の機能など

+ [Cloud Armor](./feature-cloud-armor)
+ [Cloud DNS](./feature-cloud-dns)
+ [Config Connector](./feature-config-connector)
+ [IAP](./feature-iap)
  + Ingress に IAP を付与するやり方 ( 正確には BackendConfig を設定し、 Service に関連付けする )
+ [nodeSelector](./feature-nodeselector)
  + Pod を特定のノードプールに明示的にデプロイする
+ [SSL](./feature-ssl)
+ [Workload Identity](./feature-workload-identity)

## Sample

+ [Laravel](./sample-laravel)
+ [WordPress](./sample-wordpress)

## [コストについて](./_billing/)

+ [料金について](./_billing/README.md#料金について)
+ [Namespace 毎にコストを可視化する方法](./_billing/README.md#namespace-毎にコストを可視化する方法)


## Tips

+ [Optimizing IP address allocation](./xx_flexible-pod-cidr)




+ [Namespace 毎にコストを可視化する方法]

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
Node pool upgrade strategies
https://cloud.google.com/kubernetes-engine/docs/concepts/node-pool-upgrade-strategies#blue-green-upgrade-strategy
```

```
GKE: Concepts of Networking
https://www.youtube.com/watch?v=aVBV4O3h4AY
```
