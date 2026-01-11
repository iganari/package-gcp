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
