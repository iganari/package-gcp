# Tips: Cloud SQL におけるパラメータを変更したい時

+ :warning: この情報は 2020/03/03 に書きました。

## 手段

Flag 機能を使うことで、MySQL のパラメータなどを変更出来ます。

### MySQL 版

種類 | Flag のドキュメント | 変更可能な Flag の一覧の URL
:-| :- | :-
MySQL 版 | https://cloud.google.com/sql/docs/mysql/flags |  https://cloud.google.com/sql/docs/mysql/flags#list-flags
PostgreSQL 版 | https://cloud.google.com/sql/docs/postgres/flags | https://cloud.google.com/sql/docs/postgres/flags#list-flags-postgres
SQL Server | https://cloud.google.com/sql/docs/sqlserver/flags | https://cloud.google.com/sql/docs/sqlserver/flags#list-flags-sqlserver
  
## コマンド例 (MySQL 版の例)

+ gcloud

```
gcloud sql instances patch [INSTANCE_NAME] --database-flags [FLAG1=VALUE1,FLAG2=VALUE2]
```
```
### ex

gcloud sql instances patch ${instance_name} \
    --database-flags FLAG1=VALUE1,FLAG2=VALUE2
```

+ 参考
  + https://cloud.google.com/sql/docs/mysql/flags#clearing_all_flags_to_their_default_value

## gcloud コマンドの実施例

Cloud SQL にログイン後 (Cloud SQL Proxy などを用いて)

+ 現状の設定の確認をします。

```
MySQL [(none)]> show variables like '%time_zone%';
+------------------+--------+
| Variable_name    | Value  |
+------------------+--------+
| system_time_zone | UTC    |
| time_zone        | SYSTEM |
+------------------+--------+
```
```
MySQL [(none)]> show variables like '%character%';
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8                       |
| character_set_connection | utf8                       |
| character_set_database   | utf8                       |
| character_set_filesystem | binary                     |
| character_set_results    | utf8                       |
| character_set_server     | utf8                       |
| character_set_system     | utf8                       |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+
```

+ gcloud コマンドを用いて、Flag を設定してみます。
  + :warning: 再起動が必要な Flag に関しては勝手に再起動が走ります。

```
gcloud sql instances patch ${instance_name} \
    --database-flags default_time_zone=+09:00,character_set_server=utf8mb4
```

+ 再び、設定の確認をします。

```
MySQL [(none)]> show variables like '%time_zone%';
+------------------+--------+
| Variable_name    | Value  |
+------------------+--------+
| system_time_zone | UTC    |
| time_zone        | +09:00 |
+------------------+--------+
```
```
MySQL [(none)]> show variables like '%character%';
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8                       |
| character_set_connection | utf8                       |
| character_set_database   | utf8mb4                    |
| character_set_filesystem | binary                     |
| character_set_results    | utf8                       |
| character_set_server     | utf8mb4                    |
| character_set_system     | utf8                       |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+
```

---> 意図通り、変更出来ていることが確認出来ました :raised_hands:

+ gcloud コマンドでも確認してみましょう。

```
gcloud sql instances describe ${instance_name} --format=json | jq .settings.databaseFlags[]
```
```
### ex

# gcloud sql instances describe ${instance_name} --format=json | jq .settings.databaseFlags[]
{
  "name": "default_time_zone",
  "value": "+09:00"
}
{
  "name": "character_set_server",
  "value": "utf8mb4"
}
```

---> gcloud コマンドでも、変更出来ていることが確認出来ました :raised_hands:

## Terraform の例

+ `google_sql_database_instance` の `settings.database_flags` を使用します。

```
### ex

resource "google_sql_database_instance" "pkg-gcp" {
  name             = "Your instance name"
  region           = "asia-northeast1"
  database_version = "MYSQL_5_7"

  settings {
    tier             = "db-f1-micro"
    replication_type = "SYNCHRONOUS"
    database_flags {
      name = "default_time_zone"
      value = "+09:00"
    }
    database_flags {
      name = "character_set_server"
      value = "utf8mb4"
    }
  }
}
```

## まとめ

マネージド故に設定出来るパラメータと出来ないパラメータがあります。

設定出来るパラメータはなるべくコードで変更しましょう。

Have fun!! :)
