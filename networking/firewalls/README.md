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

## 参考

+ https://cloud.google.com/load-balancing/docs/health-checks?hl=ja
+ https://cloud.google.com/load-balancing/docs/health-check-concepts?hl=ja#ip-ranges
+ https://cloud.google.com/iap/docs/using-tcp-forwarding#create-firewall-rule

