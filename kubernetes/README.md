# GKE サンプル

## 説明

+ GCP 上で Kubernetes を使うためのサンプルを集めています。
  + つまり、 基本的には GKE のサンプルがメインになります。

## 先にインストールしておきたいコマンド

```
gcloud components install beta -q &&\
gcloud components update -q && \
gcloud components install kubectl -q
```

## コンテンツ

+ [gcloud container clusters](./_gcloud_container_clusters)
+ [cluster-basic](./cluster-basic)
    + [gcloud](./cluster-basic/gcloud)
    + [terraform](./cluster-basic/terraform)
+ [cluster-private](./cluster-private)
    + [gcloud](./cluster-private/gcloud)
    + [terraform](./cluster-private/terraform)
+ [cluster-version-upgrade](./cluster-version-upgrade)
+ [configure-backend-service](./configure-backend-service)
+ [feature-cloud-armor | Cloud Armor を試す](./feature-cloud-armor)
+ [feature-cronjobs](./feature-cronjobs)
+ [feature-workload-identity | Workload Identity を試す](./feature-workload-identity)
+ [handson](./handson)
+ [helm](./helm)
+ [sample-version](./sample-version)
+ [tips](./tips)
+ [tutorials_hello-app](./tutorials_hello-app)
+ [wordpress](./wordpress)

