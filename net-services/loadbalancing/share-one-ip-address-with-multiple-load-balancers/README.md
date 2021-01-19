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

## ネットワークの作成

+ VPC ネットワークの作成

```
WIP
```

+ サブネットの作成

```
WIP
```

+ パブリックIPアドレスの予約

```
### Cloud NAT で使用する ---> a①
WIP

### Bastion VM で使用する ---> a②
```

+ Cloud Router の作成

```
WIP
```

+ Cloud NAT の作成

```
WIP
```

+ Firewall の作成

```
### 同 VPC ネットワーク内はすべて許可
WIP

### GCP の LB の IP アドレスからの通信を許可
WIP
```

## VM を作成

+ Bastion VM
    + a② を使用します

```
WIP
```
