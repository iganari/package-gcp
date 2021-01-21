# [WIP] share-one-ip-address-with-multiple-load-balancers

![](./image.png)


## cmd

+ ip addr 予約
  + lb用
  + nat用
+ network 作成
+ firewall
  + lb からの通信許可
  + bastion からの通信許可
+ 

## 要旨

+ GCP にログイン
+ ネットワークの作成

## GCP にログイン

```
gcloud auth login -q
```

+ 環境変数に入れておく

```
export _gcp_pj_id='Your GCP Project ID'
export _common='oneipsharelb'
export _region='asia-northeast1'
```

## ネットワークの作成

+ VPC ネットワークの作成

```
gcloud beta compute networks create ${_common}-network \
    --subnet-mode=custom \
    --project ${_gcp_pj_id}
```

+ サブネットの作成

```
gcloud beta compute networks subnets create ${_common}-subnets \
    --network ${_common}-network \
    --region ${_region} \
    --range 172.16.0.0/12 \
    --project ${_gcp_pj_id}
```

+ パブリックIPアドレスの予約

```
### Cloud NAT で使用する ---> a①
gcloud beta compute addresses create ${_common}-ip-nat \
    --region ${_region} \
    --project ${_gcp_pj_id}


### Bastion VM で使用する ---> a②
gcloud beta compute addresses create ${_common}-ip-vm \
    --region ${_region} \
    --project ${_gcp_pj_id}


### GCLB で使用する ---> a③
gcloud beta compute addresses create ${_common}-ip-lb \
    --ip-version=IPV4 \
    --global \
    --project ${_gcp_pj_id}
```

+ Cloud Router の作成

```
gcloud beta compute routers create ${_common}-router \
    --network ${_common}-network \
    --region ${_region} \
    --project ${_gcp_pj_id}
```

+ Cloud NAT の作成
    + a① を使用します

```
gcloud beta compute routers nats create ${_common}-nat \
    --router-region ${_region} \
    --router ${_common}-router \
    --nat-all-subnet-ip-ranges \
    --nat-external-ip-pool ${_common}-ip-nat \
    --project ${_gcp_pj_id}
```

+ Firewall の作成
    + https://cloud.google.com/load-balancing/docs/https/?hl=en#firewall_rules
    + https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges
    + :warning: range などがまだちゃんと精査出来ていない

```
### 同 VPC ネットワーク内はすべて許可
gcloud beta compute firewall-rules create ${_common}-allow-internal-all \
    --network ${_common}-network \
    --allow tcp:0-65535,udp:0-65535,icmp \
    --project ${_gcp_pj_id}

### GCP の LB の IP アドレスからの通信を許可
gcloud beta compute firewall-rules create ${_common}-allow-gclb \
    --network ${_common}-network \
    --allow tcp:0-65535,udp:0-65535,icmp \
    --source-ranges="130.211.0.0/22,35.191.0.0/16" \
    --project ${_gcp_pj_id}
```

## VM を作成

+ Bastion VM の作成
    + a② を使用します

```
WIP
```

+ web VM の作成
    + Ubuntu を使用

```
WIP
```

## web VM を設定

+ nginx をいれる

```
apt install nginx
```

+ curl で確認

```
curl localhost
```

## template を作る

LB のバックエンドに登録するため

```
WIP
```

## LB 作成

なんか色々作る

IP アドレスが共通で使えるとこをやりたい

```
WIP
```

## LB でマネージドSSLを設定

```
WIP
```

## Cloud Armor をつける

+ L7 の LB にはつけられる

```
WIP
```

## 確認

GCP 外から確認しよう

複数のLBから来ていることをログから確認しよう



## 疑問点

+ GCLB と TCPLB で IP address の共有は出来るのか?


## 削除コマンド


+ ネットワーク系の削除

```
### FireWall Rule
gcloud beta compute firewall-rules delete ${_common}-allow-internal-all \
    --project ${_gcp_pj_id} \
    -q

gcloud beta compute firewall-rules delete ${_common}-allow-gclb \
    --project ${_gcp_pj_id} \
    -q


### Cloud NAT
gcloud beta compute routers nats delete ${_common}-nat \
    --router-region ${_region} \
    --router ${_common}-router \
    --project ${_gcp_pj_id} \
    -q


### Cloud Router
gcloud beta compute routers delete ${_common}-router \
    --region ${_region} \
    --project ${_gcp_pj_id} \
    -q


### External IP Address
gcloud beta compute addresses delete ${_common}-ip-nat \
    --region ${_region} \
    --project ${_gcp_pj_id} \
    -q

gcloud beta compute addresses delete ${_common}-ip-vm \
    --region ${_region} \
    --project ${_gcp_pj_id} \
    -q

gcloud beta compute addresses delete ${_common}-ip-lb \
    --global \
    --project ${_gcp_pj_id} \
    -q


### Subnet
gcloud beta compute networks subnets delete ${_common}-subnets \
    --region ${_region} \
    --project ${_gcp_pj_id} \
    -q


### VPC Network
gcloud beta compute networks delete ${_common}-network \
    --project ${_gcp_pj_id} \
    -q
```



## おわり

:)


