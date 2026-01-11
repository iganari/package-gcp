# 便利 SQL

## 自身で作成した一般ユーザーやアプリケーション用ユーザーのみを抽出した `ユーザー一覧` を表示

- 以下を除外する
  - プレフィックスが `CloudSQL` なもの
  - PostgreSQL標準の内部ユーザー (postgres や pg_ で始まるもの) 

```
SELECT 
    rolname AS username,
    rolsuper AS is_superuser,
    rolcanlogin AS can_login
FROM 
    pg_roles
WHERE 
    rolname NOT LIKE 'cloudsql%' -- CloudSQL管理ユーザー除外
    AND rolname NOT LIKE 'pg_%'  -- システムロール除外
    AND rolname <> 'postgres'     -- 管理者(postgres)を除外したい場合
ORDER BY 
    rolname;
```

## テーブルごとの権限逆引き（誰が・何ができるか）

```
SELECT
    n.nspname AS schema_name,
    c.relname AS table_name,
    (aclexplode(c.relacl)).grantee::regrole AS user_name,
    (aclexplode(c.relacl)).privilege_type AS privilege,
    (aclexplode(c.relacl)).is_grantable AS is_grantable
FROM
    pg_class c
JOIN
    pg_namespace n ON n.oid = c.relnamespace
WHERE
    c.relkind IN ('r', 'v', 'm') -- r:テーブル, v:ビュー, m:マテリアライズドビュー
    AND n.nspname NOT LIKE 'pg_%'
    AND n.nspname <> 'information_schema'
ORDER BY
    schema_name, table_name, user_name;
```

## スキーマごとの権限逆引き

```
SELECT
    nspname AS schema_name,
    (aclexplode(nspacl)).grantee::regrole AS user_name,
    (aclexplode(nspacl)).privilege_type AS privilege,
    (aclexplode(nspacl)).is_grantable AS is_grantable
FROM
    pg_namespace
WHERE
    nspname NOT LIKE 'pg_%'
    AND nspname <> 'information_schema'
ORDER BY
    schema_name, user_name;
```

- privilege_type の種類:
  - SELECT: 読み取り権限
  - INSERT/UPDATE/DELETE: 書き込み権限
  - TRUNCATE: 削除（全行）権限
  - REFERENCES: 外部キー参照権限（DDLに関わる）
  - TRIGGER: トリガー作成権限
