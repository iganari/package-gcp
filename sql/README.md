# Cloud SQL

## 概要

WIP

## 基本的な使いかた

+ [gcloud コマンド](./_gcloud/README.md)
+ [database flags](./_flag/README.md)

## Tips

+ [最大同時接続数](./tips-maximum_concurrent_connections)
+ [Cloud SQL で利用できるデータベースの種類とバージョン](https://cloud.google.com/sql/docs/mysql/admin-api/rest/v1beta4/SqlDatabaseVersion)


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
+ [PostgreSQL のセキュリティ](https://cloud.google.com/sql/docs/postgres/data-privacy-strategies?hl=en)
  + [列レベルのセキュリティ (Column Level Security)](https://cloud.google.com/sql/docs/postgres/data-privacy-strategies?hl=en#column-level-security)
  + [行レベルのセキュリティ (Row Level Security)](https://cloud.google.com/sql/docs/postgres/data-privacy-strategies?hl=en#row-level-security)

## サンプル

+ [Terraform で Cloud SQL を作成する](./samples-terraform/)
+ [サンプルのダミーデータをいれる](./samples-dummydata/)
+ [インスタンスの起動、停止、再起動](https://cloud.google.com/sql/docs/mysql/start-stop-restart-instance?hl=en)


## 公式ブログ

+ [開発費用の削減: Cloud SQL インスタンスの起動と停止をスケジュールする](https://cloud.google.com/blog/ja/topics/developers-practitioners/lower-development-costs-schedule-cloud-sql-instances-start-and-stop)
