# Configuring database flags

https://cloud.google.com/sql/docs/mysql/flags

データベースの flag の設定など

例えば、スロークエリを Cloud Logging に出す際は flag を設定する必要がある

## MySQL

WIP

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
