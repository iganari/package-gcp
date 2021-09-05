# Network services

## コンポーネント

+ [Load balancing](./loadbalancing)
+ [Cloud DNS](./dns)
+ [Cloud CDN]
+ [Cloud NAT]

## IP アドレスについて

### ロードバランサ の上り（内向き）

[ヘルスチェックの概要 | プローブ IP 範囲とファイアウォール ルール](https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges)

プロダクト | プローブのソース IP の範囲
:- |:-
内部 TCP / UDP 負荷分散<br>内部 HTTP(S) 負荷分散<br>TCP プロキシ負荷分散<br>SSL プロキシ負荷分散<br>Traffic Director | 35.191.0.0/16<br>130.211.0.0/22
ネットワーク負荷分散 |  35.191.0.0/16<br>209.85.152.0/22<br>209.85.204.0/22
