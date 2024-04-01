# Memorystore for Memcached

## 概要

TBD

+ https://cloud.google.com/memorystore/docs/memcached?hl=en
+ https://cloud.google.com/memorystore/docs/memcached/memcached-overview?hl=en

## API 有効化

```
export _gc_pj_id='Your Google Cloud Project ID'

gcloud beta services enable redis.googleapis.com --project ${_gc_pj_id}
```

## コンテンツ

### [基本的な構築方法](./basic-instance/)

Memcached Instance の基礎構築の例

## 設定

ポートは memcached の基本ポートである **11211**

## リンク

TBD

## 注意点

```
Memorystore for Memcached インスタンスに接続するには、接続するクライアントがインスタンスと同じリージョン内にある必要がある
https://cloud.google.com/memorystore/docs/memcached/regions?hl=en
```

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/memorystore/memcached/tips-01.png)
