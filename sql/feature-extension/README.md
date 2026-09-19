# 拡張機能について

## Cloud SQL for PostgreSQL の場合

- 拡張機能の確認

TBD

## 疎通確認方法

### アプローチ 1

システムカタログを参照するダミー外部テーブルを作る

```
-- 1. リモートのシステムカタログ (pg_class) の一部だけを参照するテストテーブルを作成
CREATE FOREIGN TABLE test_fdw_ping (
    relname name
)
SERVER cloudsql_a_server
OPTIONS (schema_name 'pg_catalog', table_name 'pg_class');

-- 2. テストクエリを実行
SELECT * FROM test_fdw_ping LIMIT 1;
```

### アプローチ 2

`dblink` 拡張機能を使って Ping テストをする

```
-- 1. dblink 拡張機能を有効化（Cloud SQL で標準サポートされています）
CREATE EXTENSION IF NOT EXISTS dblink;

-- 2. 接続テストを実行（IP、DB名、ユーザー、パスワードを直接指定）
SELECT dblink_connect('test_conn', 'host=10.1.2.3 port=5432 dbname=target_database_name user=cloudsql_a_user password=your_password');
```

