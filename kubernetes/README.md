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

+ [basic-cluster](./README.md#basic-cluster)
+ [cluster-private](./README.md#private-cluster)
+ [sample-version]
+ [wordpress](./README.md#wordpress)


## Basic Cluster

+ [basic-private](./cluster-basic/README.md)
    + 通常の GKE クラスタ

## Private Cluster

+ [cluster-private](./cluster-private/README.md)
    + 限定公開クラスタ と呼ばれる、ノードのネットワークの権限を制御して、よりセキュアなクラスタを構築・運用するためのクラスタです。

## WordPress

+ [With MySQL Pod]
    + WIP

+ [With CloudSQL](./wordpress/with-cloudsql)
    + GKE 上に Cloud SQL を使用した WordPress を作成する

+ [Costom Container With CloudSQL]
    + WIP


## Helm

WIP
