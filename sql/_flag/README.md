# Configuring database flags

https://cloud.google.com/sql/docs/mysql/flags

データベースの flag の設定など

例えば、スロークエリを Cloud Logging に出す際は flag を設定する必要がある

ログに関しては自動でローテーションかつ自動で削除されてしまうため、 Cloud Logging に吐き出すのはほぼ必須である -> [フラグの使用に関するヒント](https://cloud.google.com/sql/docs/mysql/flags#tips)

## MySQL

設定できるフラグは [サポートされているフラグ](https://cloud.google.com/sql/docs/mysql/flags#list-flags-mysql) にあるもののみ

以下はよく設定するフラグ

+ 一般クエリーログを Cloud Logging に吐き出す場合
  + `log_output` = `FILE` かつ `general_log` = `On`
+ スロークエリログを Cloud Logging に吐き出す場合
  + `log_output` = `FILE` かつ `slow_query_log` = `On`
  + `long_query_time` にてスロークエリのしきい値を決める



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
