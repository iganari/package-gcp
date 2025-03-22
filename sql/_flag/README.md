# Configuring database flags

https://cloud.google.com/sql/docs/mysql/flags

データベースの flag の設定など

例えば、スロークエリを Cloud Logging に出す際は flag を設定する必要がある

ログに関しては自動でローテーションかつ自動で削除されてしまうため、 Cloud Logging に吐き出すのはほぼ必須である -> [フラグの使用に関するヒント](https://cloud.google.com/sql/docs/mysql/flags#tips)

## MySQL

設定できるフラグは [サポートされているフラグ](https://cloud.google.com/sql/docs/mysql/flags#list-flags-mysql) にあるもののみ

以下はよく設定するフラグ

- 一般クエリーログを Cloud Logging に吐き出す場合
  - `log_output` = `FILE` かつ `general_log` = `On`
- スロークエリログを Cloud Logging に吐き出す場合
  - `log_output` = `FILE` かつ `slow_query_log` = `On`
  - `long_query_time` にてスロークエリのしきい値を決める
- time zone の修正
  - `default_time_zone` = `+09:00`

### 最大同時接続数 (max_connections)

- 最大同時接続数
  - https://cloud.google.com/sql/docs/quotas#maximum_concurrent_connections

- 確認コマンド

```
SHOW VARIABLES LIKE "max_connections";
```

- デフォルト接続数上限

マシンタイプ | デフォルトの同時接続数
:- | :-
db-f1-micro | 250
db-g1-small | 1,000
その他のすべてのマシンタイプ | 4,000

※ 割当 (Quotas) で上限緩和申請が可能

## PostgreSQL

```
PostgreSQLおよびSQLServer for Cloud SQLは、ユーザーのニーズに基づいてタイムゾーンを調整するためのタイムゾーンフラグをサポートしていません。
いくつかの回避策があります。
セッションごとにタイムゾーンを設定できますが、ログオフすると期限切れになります。 より良い解決策は、データベースに接続し、データベースのタイムゾーンをユーザーごとまたはデータベースごとに目的のタイムゾーンに設定することです。
```
```
ALTER DATABASE dbname SET TIMEZONE TO 'timezone';
ALTER USER username SET TIMEZONE TO 'timezone';
```

https://cloud.google.com/sql/docs/postgres/flags#troubleshooting-flags

### 最大同時接続数 (max_connections)

- 確認コマンド

```
SELECT * FROM pg_settings WHERE name = 'max_connections';
```

- デフォルト接続上限

```
マシンタイプ構成設定により、選択したコア数に基づき、自動的に利用可能なメモリサイズの範囲が調整される
```

