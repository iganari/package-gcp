# 限定公開クラスタ (Creating a private cluster)

## これは何？

公式ドキュメント

+ https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters

どんなものなの??

+ 他の VPC ネットワークから隔離したネットワーク上に K8s を展開します
+ 限定公開クラスタ内の Node 及び、 Pod から外にアクセスする場合は、 ロードバランサ経由で外部からアクセスを受信出来ます。


## 実際に構築してみる

+ [gcloud 版](./gcloud/README.md)
+ [ WIP: Terraform 版]()
