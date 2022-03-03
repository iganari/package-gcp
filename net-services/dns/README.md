# Cloud DNS

## 概要

GCP のマネージド DNS ( Domain Name System ) サービス

低レイテンシで高可用性を謳っている

大きく分けて 2 つのモードがあり、「一般公開ゾーン」と「限定公開ゾーン」がある

共有 VPC なども使えるが、制約もある

+ GCPの制約
  + オンプレミスの DNS サーバーを参照するには、 Cloud DNS の DNS 転送により実現される。
    + DNS 転送はインバウンド・アウトバウンドの両方向の設定があり、双方向の設定により参照が可能になる。
    + DNS 転送はVPCネットワークピアリングを使った VPC ネットワークを跨いだ参照はできない。
  + VPC ネットワークピアリングにより接続された VPC ネットワークが、参照するには DNS ピアリングも設定してないといけない


```
Cloud DNS | OverView
https://cloud.google.com/dns/docs/overview
```
