# [WIP] External IP addresses

## 概要

外部のインターネットからアクセス出来る IP アドレスを予約し、利用することが出来る

### 種類と特徴

+ 種類
  + Premium Tier
  + Standard Tier
+ コストのついて
  + [Network Service Tiers の概要](https://cloud.google.com/network-tiers/docs/overview?hl=en)
  + [Network Service Tiers の料金](https://cloud.google.com/network-tiers/pricing?hl=en)

## 準備

```
export _gc_pj_id='Your Google Cloud Project ID'
```



## 現在、予約している IP アドレスを表示する

```
gcloud beta compute addresses list --project ${_gc_pj_id}

OR

gcloud beta compute addresses list --project ${_gc_pj_id} --format json
```

## 外部 IP アドレスの取得方法

+ 種類
  + region
  + global

### region

+ 使用例
    + Cloud NAT や Cpmpute Engine

```
gcloud beta compute addresses create ${_common}-ip-addr \
  --region ${_region} \
  --project ${_gc_pj_id}
```

### global

+ 使用例
    + GCLB

```
gcloud beta compute addresses create mix-ip-addr \
  --ip-version=IPV4 \
  --global \
  --project ${_gc_pj_id}
```

