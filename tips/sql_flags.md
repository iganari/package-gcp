# Tips: Cloud SQL for MySQL におけるパラメータを変更したい時

:waring: この情報は 2020/03/03 において最新です。

## 手段

Flag 機能を使うことで、MySQL のパラメータなどを変更出来ます。

### MySQL 版

+ Flag のドキュメント
  + https://cloud.google.com/sql/docs/mysql/flags
+ 変更可能な flags の一覧
  + https://cloud.google.com/sql/docs/mysql/flags#list-flags

### PostgreSQL 版

+ Flag のドキュメント
  + https://cloud.google.com/sql/docs/postgres/flags
+ 変更可能な flags の一覧
  + https://cloud.google.com/sql/docs/postgres/flags#list-flags-postgres

### SQL Server 版

+ Flag のドキュメント
  + https://cloud.google.com/sql/docs/sqlserver/flags
+ 変更可能な flags の一覧
  + https://cloud.google.com/sql/docs/sqlserver/flags#list-flags-sqlserver

## 注意点

+ Flag の種類によっては、Cloud SQL のインスタンスの可用性や安定性に影響を及ぼし、SLA 対象外になる可能性があるので注意
  + https://cloud.google.com/sql/docs/mysql/operational-guidelines
  
## コマンド例 ( MySQL 版の例)

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

```
gcloud sql instances patch flagchecksql \
    --database-flags character_set_server=utf8mb4
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

+ :warning: 注意
  + 再起動が必要な Flag に関しては勝手に再起動が走ります。

## Terraform の例

+ `google_sql_database_instance` の `settings.database_flags` を使用します。

```
### ex

resource "google_sql_database_instance" "pkg-gcp" {
  name             = "Your instance name"
  region           = "asia-northeast1"
  database_version = "MYSQL_5_7"

  settings {
    tier             = local.instance_tier
    replication_type = "db-f1-micro"
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
      start_time         = "03:00"
    }
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
