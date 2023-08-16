# Cloud SQL

## 概要

WIP

## 基本的な使いかた

+ [gcloud コマンド](./_gcloud/README.md)
+ [database flags](./_flag/README.md)

## Tips

+ [最大同時接続数](./tips-maximum_concurrent_connections)

## 機能および構築例

+ [プライベート IP アドレスしか持たない Cloud SQL の作成](./feature-only-private-ip-addr)
  + プライベート IP アドレスしか持たない Cloud SQL の作成
+ [WIP][IAP to Cloud SQL](./feature-iap/README.md)
  + IAP 越しに パブリック IP アドレスが無い Cloud SQL に パブリック IP アドレスが無い GCE を通じてログインします
+ [WIP][Login to Cloud SQL using the Cloud SQL Auth proxy](./feature-sql-auth-proxy/README.md)
  + Cloud SQL Auth proxy を使用して、外部の VM から Cloud SQL にログインします
+ [Copy Another Cloud SQL](./copy-another-sql)
  + Cloud SQL のデータをコピーしたい場合のやり方
+ [レプリケーションについて](./feature-replication/)
  + Cloud SQL のリードレプリカや、外部の DB とのレプリケーションについて
+ Cloud SQL Insights について
  + https://cloud.google.com/blog/ja/products/databases/boost-your-query-performance-troubleshooting-skills-cloud-sql-insights

## サンプル

+ [Terraform で Cloud SQL を作成する](./samples-terraform/)
+ [サンプルのダミーデータをいれる](./samples-dummydata/)
