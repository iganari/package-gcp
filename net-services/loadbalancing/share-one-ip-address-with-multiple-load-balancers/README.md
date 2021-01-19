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
WIP

### LB で使用する ---> a③
WIP

```

+ Cloud Router の作成

```
WIP
```

+ Cloud NAT の作成
    + a① を使用します

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

## 確認

GCP 外から確認しよう

複数のLBから来ていることをログから確認しよう

## おわり

:)
