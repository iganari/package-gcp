# Shared VPC

## 概要

GCP の組織内の複数の GCP Project で VPC を共有することが出来る

関係としては親子関係であり、親(ホストプロジェクト)のVPCネットワークのサブネットを、子(サービスプロジェクト)が使えるようにします。

親と子は 1:N の関係であり、共有するサブネット自体も 1:N の関係です


```
公式ドキュメント
Shared VPC overview | https://cloud.google.com/vpc/docs/shared-vpc
```
