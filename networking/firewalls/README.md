# Firewall

## 大抵の Load Balancing の場合

+ 以下を許可

```
35.191.0.0/16
130.211.0.0/22
```

---> 詳しくは [Package GCP | Network services](../../net-services)

## Network Load Balancing の場合

+ 以下を許可

```
35.191.0.0/16
209.85.152.0/22
209.85.204.0/22
```

---> 詳しくは [Package GCP | Network services](../../net-services)

## `IAP` 経由で内部の VM にアクセスする等の場合、許可すべき IP アドレス

+ 以下を許可

```
35.235.240.0/20
```

https://cloud.google.com/iap/docs/using-tcp-forwarding#create-firewall-rule

## 命名規則例

- iganari 的おすすめ

```
{{ VPC ネットワーク名 }}-{{ allow|deny }}-{{ ingress|egress|internal }}-{{ ports(分かりやすい形) }}
```

## Firewall Rule の仕様

### `上り` と `下り` について

+ 上り = 内向き
+ 下り = 外向き

向きはあくまで 送信元 -> 送信先 を表しているので、必ずしも WAN / LAN のことを指している訳では無い

Google Cloud 内の同 VPC Network 内の通信でも制御できる

もちろん WAN  LAN の通信も制御できる

https://cloud.google.com/vpc/docs/firewalls#direction_of_the_rule

### ステートフルである

https://cloud.google.com/vpc/docs/firewalls#specifications


## 参考

+ https://cloud.google.com/load-balancing/docs/health-checks?hl=ja
+ https://cloud.google.com/load-balancing/docs/health-check-concepts?hl=ja#ip-ranges
+ https://cloud.google.com/iap/docs/using-tcp-forwarding#create-firewall-rule

