# 基本的な構築方法

## 準備

環境変数を設定しておく

```
export _gc_pj_id='Your Google Cloud Project ID'

export _common='pkg-gcp-memcached'
```

## Network の作成

参考 ---> TBD

+ VPC Network の作成

```
gcloud beta compute networks create ${_common}-network \
  --subnet-mode=custom \
  --project ${_gc_pj_id}
```

+ Private Services Access の設定
  + https://cloud.google.com/vpc/docs/configure-private-services-access?hl=en#procedure
  + `Prefix Length` は自動にするため指定しない

```
gcloud compute addresses create ${_common}-psa \
  --global \
  --network ${_common}-network \
  --purpose VPC_PEERING \
  --prefix-length 16 \
  --project ${_gc_pj_id}
```

+ Private Connection の作成

```
gcloud services vpc-peerings connect \
  --network ${_common}-network \
  --service servicenetworking.googleapis.com \
  --ranges ${_common}-pc \
  --project ${_gc_pj_id}
```

## Memcached Instance の作成

TBD

## 注意点

紐づける VPC ネットワーク にて **Private Services Access が必要** になる

[公式ドキュメント | Private services access](https://cloud.google.com/vpc/docs/private-services-access?hl=en)

<details>
<summary>スクショ</summary>

![](./_img/psa.png)

</details>
