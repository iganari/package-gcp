# Cloud SQL

## 概要

WIP

## 基本的な使いかた

+ [gcloud コマンド](./_gcloud/README.md)
+ [database flags](./_flag/README.md)

## 機能および構築例

+ [Login to Cloud SQL using the Cloud SQL Auth proxy](./feature-cloud-sql-auth-proxy/README.md)
  + Cloud SQL Auth proxy を使用して、外部の VM から Cloud SQL にログインします
+ [IAP to Cloud SQL](./feature-iap/README.md)
  + IAP 越しに パブリック IP アドレスが無い Cloud SQL に パブリック IP アドレスが無い GCE を通じてログインします
+ [プライベート IP アドレスしか持たない Cloud SQL の作成](./feature-only-private-ip-addr)
  + プライベート IP アドレスしか持たない Cloud SQL の作成
+ [レプリケーションについて](./feature-replication/)
  + Cloud SQL のリードレプリカや、外部の DB とのレプリケーションについて


+ Cloud SQL Insights について
  + https://cloud.google.com/blog/ja/products/databases/boost-your-query-performance-troubleshooting-skills-cloud-sql-insights
+ [PostgreSQL のセキュリティ](https://cloud.google.com/sql/docs/postgres/data-privacy-strategies?hl=en)
  + [列レベルのセキュリティ (Column Level Security)](https://cloud.google.com/sql/docs/postgres/data-privacy-strategies?hl=en#column-level-security)
  + [行レベルのセキュリティ (Row Level Security)](https://cloud.google.com/sql/docs/postgres/data-privacy-strategies?hl=en#row-level-security)

## サンプル

+ [Copy Another Cloud SQL](./samples-copy-another-sql)
  + Cloud SQL のデータをコピーしたい場合のやり方
+ [サンプルのダミーデータをいれる](./samples-dummydata/)
+ [Terraform で Cloud SQL を作成する](./samples-terraform/)

## Tips

+ [最大同時接続数](./tips-maximum-concurrent-connections)
+ [Cloud SQL で利用できるデータベースの種類とバージョン](https://cloud.google.com/sql/docs/mysql/admin-api/rest/v1beta4/SqlDatabaseVersion)
+ [インスタンスの起動、停止、再起動](https://cloud.google.com/sql/docs/mysql/start-stop-restart-instance?hl=en)

## 公式ブログ

+ [開発費用の削減: Cloud SQL インスタンスの起動と停止をスケジュールする](https://cloud.google.com/blog/ja/topics/developers-practitioners/lower-development-costs-schedule-cloud-sql-instances-start-and-stop)
