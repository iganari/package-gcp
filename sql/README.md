# Cloud SQL

## 概要

- Google Cloud のフルマネージドリレーショナルデータベースサービスです
- 使用できるデータベースは MySQL, PostgreSQL, SQL Server です
- 外部 IP アドレスを標準で搭載していて、さらに VPC を設定することで、内部 IP アドレスも持つことが出来ます
- Google Cloud のコンピュートリソース (GCE, App Engine, Cloud Run, Cloud Run Functions, GKE など) と内部 IP アドレス経由で接続することが出来ます
- Google Cloud の他の SaaS サービスとシームレスに接続することが出来ます

![](https://raw.githubusercontent.com/iganari/artifacts/refs/heads/main/googlecloud/sql/2025-sql-overview-01.png)

![](https://raw.githubusercontent.com/iganari/artifacts/refs/heads/main/googlecloud/sql/2025-sql-overview-02.png)

## 基本的な使いかた

- [gcloud コマンド](./_gcloud/README.md)
- [database flags](./_flag/README.md)

## Tips

- [Cloud SQL で利用できるデータベースの種類とバージョン](https://cloud.google.com/sql/docs/mysql/admin-api/rest/v1beta4/SqlDatabaseVersion)

## 機能および構築例

- [バックアップについて](./feature-backup/)
  - Cloud SQL のバックアップについての覚書
- [プライベート IP アドレスしか持たない Cloud SQL の作成](./feature-only-private-ip-addr)
  - プライベート IP アドレスしか持たない Cloud SQL の作成
- [IAP to Cloud SQL](./feature-iap/README.md)
  - IAP 越しに パブリック IP アドレスが無い Cloud SQL に パブリック IP アドレスが無い GCE を通じてログインします
- [Login to Cloud SQL using the Cloud SQL Auth proxy](./feature-cloud-sql-auth-proxy/README.md)
  - Cloud SQL Auth proxy を使用して、外部の VM から Cloud SQL にログインします
- [Copy Another Cloud SQL](./feature-copy-another-sql)
  - Cloud SQL のデータをコピーしたい場合のやり方
- [レプリケーションについて](./feature-replication/)
  - Cloud SQL のリードレプリカや、外部の DB とのレプリケーションについて
- Cloud SQL Insights について
  - https://cloud.google.com/blog/ja/products/databases/boost-your-query-performance-troubleshooting-skills-cloud-sql-insights
- [PostgreSQL のセキュリティ](https://cloud.google.com/sql/docs/postgres/data-privacy-strategies?hl=en)
  - [列レベルのセキュリティ (Column Level Security)](https://cloud.google.com/sql/docs/postgres/data-privacy-strategies?hl=en#column-level-security)
  - [行レベルのセキュリティ (Row Level Security)](https://cloud.google.com/sql/docs/postgres/data-privacy-strategies?hl=en#row-level-security)

## サンプル

- [Terraform で Cloud SQL を作成する](./samples-terraform/)
- [サンプルのダミーデータをいれる](./samples-dummydata/)
- [インスタンスの起動、停止、再起動](https://cloud.google.com/sql/docs/mysql/start-stop-restart-instance?hl=en)

## 公式ブログ

- [開発費用の削減: Cloud SQL インスタンスの起動と停止をスケジュールする](https://cloud.google.com/blog/ja/topics/developers-practitioners/lower-development-costs-schedule-cloud-sql-instances-start-and-stop)
