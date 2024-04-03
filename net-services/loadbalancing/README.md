# Google Cloud の Load Balancing について

## 概要

+ Cloud Load Balancing overview
  + https://cloud.google.com/load-balancing/docs/load-balancing-overview

![](https://cloud.google.com/load-balancing/images/lb-simple-overview.svg)

## 種類

![](https://cloud.google.com/load-balancing/images/choose-lb-4.svg)

## 選び方

+ Choosing a load balancer
  + https://cloud.google.com/load-balancing/docs/choosing-load-balancer

![](https://cloud.google.com/load-balancing/images/choose-lb.svg)

![](https://cloud.google.com/static/load-balancing/images/lb-product-tree.svg)

## DDoS 攻撃対策について

+ デフォルトで DDoS 攻撃への対策が施されている (ただしどの程度防いでくれるかは明文化されていない)
+ 追加で Cloud Armor (WAF) をつけることで、より強固な対策をすることが出来る

[外部ロードバランサの DDoS 対策](https://cloud.google.com/load-balancing/docs/choosing-load-balancer?hl=en#ddos)

## めも

Firewall を作るときには LB の IP アドレスのレンジを許可する必要がある

https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges
