# Tips: Windows on GCE を構築する

+ ~:warning: この情報は 2020/03/10 に書きました。~
+ 執筆中です

## 手段

+ カスタムイメージを使うことでwin を作れます
  + 完全な desktop ではなく、あくまでserverです
+ 最初は注意が必要
  + セキュリティね

## Windows Server を GCE 上に構築する

### 準備

+ GCP との認証

```
gcloud auth login
```

+ 設定を変数に入れておく

```
export _region='asia-northeast1'
export _zone='asia-northeast1-a'
export _common='win-on-gce-test'
```

### ネットワークの作成

+ VPC ネットワークの作成

```
gcloud beta compute networks create ${_common}-network \
    --subnet-mode=custom
```

+ サブネットの作成

```
gcloud beta compute networks subnets create ${_common}-subnet \
    --network ${_common}-network \
    --region ${_region} \
    --range 172.16.0.0/12
```

### Firewall Rule の作成

+ RDP 用
  + テスト的に `0.0.0.0/0` を許可していますが、本来なら `{IPアドレス}/32` というように絞るべきです

```
gcloud beta compute firewall-rules create ${_common}-allow-rdp \
    --network ${_common}-network \
    --allow tcp:3389,icmp \
    --source-ranges 0.0.0.0/0
```

### GCE の作成

+ 以下の点に注意
  + Win の特定のイメージを使う
  + Firewall で RDP 用の作る

```
gcloud beta compute instances create ${_common} \
    --zone=${_zone} \
    --machine-type=n1-standard-1 \
    --subnet=${_common}-subnet \
    --maintenance-policy=MIGRATE \
    --tags=${_common}-allow-rdp \
    --image=windows-server-2019-dc-v20200211 \
    --image-project=gce-uefi-images \
    --boot-disk-size=50GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=${_common}-disk \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --reservation-affinity=any
```
```
### ex

# gcloud beta compute instances create ${_common} \
>     --zone=${_zone} \
>     --machine-type=n1-standard-1 \
>     --subnet=${_common}-subnet \
>     --maintenance-policy=MIGRATE \
>     --tags=${_common}-allow-rdp \
>     --image=windows-server-2019-dc-v20200211 \
>     --image-project=gce-uefi-images \
>     --boot-disk-size=50GB \
>     --boot-disk-type=pd-standard \
>     --boot-disk-device-name=${_common}-disk \
>     --no-shielded-secure-boot \
>     --shielded-vtpm \
>     --shielded-integrity-monitoring \
>     --reservation-affinity=any
WARNING: You have selected a disk size of under [200GB]. This may result in poor I/O performance. For more information, see: https://developers.google.com/compute/docs/disks#performance.

NAME             ZONE               MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP    STATUS
win-on-gce-test  asia-northeast1-a  n1-standard-1               172.16.0.2   34.84.176.202  RUNNING
```



## RDP クライアントを用いて、ログイン

### セキュリティを一回 off

+ IE 問題


### セキュリティを一回 on

```

```

## まとめ

GCE 上でも Windows Server は動かせます!!

Have fun!! :)
