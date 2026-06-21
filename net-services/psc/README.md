# Private Service Connect

TBD

https://docs.cloud.google.com/vpc/docs/about-vpc-hosted-services

## Network attachments

- 主な使用例
 - DataStream の Private 接続の際に **VPC Peering** or **PSC Interfaces** となり、 PSC の Network Attachement として使える

- めも
  - いわゆる NAT(NAPT) の技術なので、将来的にアタッチメントの数だけ IP アドレスを消費する === 接続するサブネットの IP アドレスのレンジとなる
