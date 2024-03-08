# VPC firewall rules

## 予約されている IP アドレスレンジ

### IAP

+ `35.235.240.0/20`

https://cloud.google.com/iap/docs/using-tcp-forwarding?hl=en

### Load Balancer

+ `35.191.0.0/16`
+ `130.211.0.0/22`
+ `209.85.152.0/22`
+ `209.85.204.0/22`

https://cloud.google.com/load-balancing/docs/health-check-concepts?hl=en#ip-ranges

## default の Firewall Rule の話

以下の Firewall Rule が default の VPC ネットワークに紐づいている

+ `10.128.0.0/9` は default の VPC ネットワークが予約している IP アドレスのレンジの**全体**


Name | Type | Targets | Filters | Protocols / ports | Action | Priority | Network | Logs
:- | :- | :- | :- | :- | :- | :- | :- | :- 
default-allow-icmp | Ingress | Apply to all | IP ranges: 0.0.0.0/0 | icmp | Allow | 65534 | default | Off
default-allow-internal | Ingress | Apply to all | IP ranges: 10.128.0.0/9 | tcp:0-65535<br>udp:0-65535<br>icmp | Allow | 65534 | default | Off
default-allow-rdp | Ingress | Apply to all | IP ranges: 0.0.0.0/0 | tcp:3389 | Allow | 65534 | default | Off
default-allow-ssh | Ingress | Apply to all | IP ranges: 0.0.0.0/0 | tcp:22 | Allow | 65534 | default | Off



## 命名規則例

```
{{ VPC ネットワーク名 }}-{{ allow/deny }}-{{ ingress/egress/internal }}-{{ ports(分かりやすい形) }}
```

がいいと思う
