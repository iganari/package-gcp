# 基本的な構築方法

## 準備

環境変数を設定しておく

```
export _gc_pj_id='Your Google Cloud Project ID'

export _common='pkg-gcp-redis'
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
  + https://cloud.google.com/memorystore/docs/redis/networking?hl=en#connection_modes
  + **Direct peering** か **Private services access** かで選ぶ必要がある
  + **Private services access** は下記が必要

```
gcloud beta compute addresses create ${_common}-psa \
  --global \
  --network ${_common}-network \
  --purpose VPC_PEERING \
  --prefix-length 16 \
  --project ${_gc_pj_id}
```

+ Private Connection の作成
  + https://cloud.google.com/memorystore/docs/redis/networking?hl=en#connection_modes
  + **Direct peering** か **Private services access** かで選ぶ必要がある
  + **Private services access** は下記が必要

```
gcloud beta services vpc-peerings connect \
  --network ${_common}-network \
  --ranges ${_common}-psa \
  --service servicenetworking.googleapis.com \
  --project ${_gc_pj_id}
```

+ Private Connnection の確認

```
gcloud beta services vpc-peerings list \
  --network ${_common}-network \
  --project ${_gc_pj_id}
```

## Redis Instance の作成

+ 環境変数を設定しておく
  + ここで MemCached の基本的なスペックを指定する

```
export _instance_tier='basic'
export _instance_num='1'
export _instance_region='asia-northeast1'
export _redis_ver='redis_7_0'

# Private services access の場合
export _connect_mode='PRIVATE_SERVICE_ACCESS'
```

+ Memorystore for Redis のインスタンスの作成

```
gcloud beta redis instances create ${_common}-redis \
  --tier ${_instance_tier} \
  --size ${_instance_num} \
  --redis-version ${_redis_ver} \
  --region ${_instance_region} \
  --connect-mode ${_connect_mode} \
  --network=projects/${_gc_pj_id}/global/networks/${_common}-network \
  --reserved-ip-range ${_common}-psa \
  --project ${_gc_pj_id}
```

+ Memorystore for Redis のインスタンスの確認

```
gcloud beta redis instances list --region ${_instance_region} --project ${_gc_pj_id}

または

gcloud beta redis instances describe ${_common}-redis --region ${{_instance_region} --project ${_gc_pj_id} --format json
```

## 99. クリーンアップ

WIP

<details>
<summary>99-1. Memcached のインスタンス削除</summary>

```
gcloud beta memcache instances delete ${_common}-memcached \
  --region ${_mem_node_region} \
  --project ${_gc_pj_id}
```

</details>


<details>
<summary>99-2. Private Connection の削除</summary>

```
gcloud beta services vpc-peerings delete \
  --network ${_common}-network \
  --service servicenetworking.googleapis.com \
  --project ${_gc_pj_id}
```

</details>

<details>
<summary>99-3. Private Services Access の削除</summary>

```
gcloud beta compute addresses delete ${_common}-psa \
  --global \
  --project ${_gc_pj_id}
```

</details>

<details>
<summary>99-4. VPC Network の削除</summary>

```
gcloud beta compute networks delete ${_common}-network \
  --project ${_gc_pj_id}
```

</details>


## 注意点

紐づける VPC ネットワーク にて **Private Services Access が必要** になる

[公式ドキュメント | Private services access](https://cloud.google.com/vpc/docs/private-services-access?hl=en)

<details>
<summary>スクショ</summary>

![](./_img/psa.png)

</details>
