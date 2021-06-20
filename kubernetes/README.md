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


## Cluster

+ [cluster-basic](./cluster-basic)
    + 通常クラスタ
    + [gcloud](./cluster-basic/gcloud)
    + [terraform](./cluster-basic/terraform)
+ [cluster-private](./cluster-private)
    + 限定公開クラスタ
    + [gcloud](./cluster-private/gcloud)
    + [terraform](./cluster-private/terraform)
+ [cluster-version-upgrade](./cluster-version-upgrade)
    + GKE クラスタのアップグレード方法

## Kind

+ [Cron Jobs](./kind-cronjobs)
+ [Ingress](./kind-ingress)
+ [Managed Certificate](./kind-managedcertificate)
+ [Persistent Volume Claim](./kind-persistentvolumeclaim)
+ [Secret](./kind-secret)
+ [StatefulSet](./kind-statufulset)

## Feature

+ [Cloud Armor](./modify-readme-only)
+ [IAP](./feature-iap)
+ [SSL](./feature-iap)
+ [Workload Identity](./feature-iap)

## Sample

+ [Laravel](./sample-laravel)
+ [WordPress](./sample-wordpress)


## Tips

+ [CIDR ranges for Standard clusters](./tips_cidr-ranges-for-clusters)


## 参考になりそうな URL

```
Best practices for GKE networking
https://cloud.google.com/kubernetes-engine/docs/best-practices/networking
```
