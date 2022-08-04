# Mode について

## 2 つの Mode がある

+ Basic mode (IP addresses/ranges only)
+ Advanced mode

## Basic mode

WIP

## Advanced mode

WIP

### ASN で許可/拒否する

ASN は https://bgpview.io/ で調べることが出来る

上記から、サーチするか、URL の PATH で入れると調べてくれる

https://bgpview.io/ip/126.227.34.83

![](./asn-01.png)

ASN が分かったら、 Cloud Armor の Rule で asn を指定する

```
### 単一の場合
origin.asn == 133165
```
```
### 複数の ASN があり、どれかに該当する場合
origin.asn == 133165 || origin.asn == 135340 || origin.asn == 14061
```
