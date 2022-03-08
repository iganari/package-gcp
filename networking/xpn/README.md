# Shared VPC

## 概要

GCP の同じ組織内の異なる複数の GCP Project で VPC を共有することが出来る

関係としては親子関係であり、親(ホストプロジェクト)のVPCネットワークのサブネットを、子(サービスプロジェクト)が使えるようにします。

組織内で複数の親を作ることは可能ですが、親と子の関係は 1:N の関係であり、共有するサブネット自体も 1:N の関係です



```
公式ドキュメント
Shared VPC overview | https://cloud.google.com/vpc/docs/shared-vpc
```
