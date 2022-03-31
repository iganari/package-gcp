# 最大同時接続数

## 概要

1 インスタンスにおいて、最大同時接続数が決まっている

割当 ( Quotas ) で上限緩和申請が可能

```
最大同時接続数
https://cloud.google.com/sql/docs/quotas#maximum_concurrent_connections
```

## MySQL

+ 確認コマンド

```
SHOW VARIABLES LIKE "max_connections";
```

+ デフォルト接続数上限

マシンタイプ | デフォルトの同時接続数
:- | :-
db-f1-micro | 250
db-g1-small | 1,000
その他のすべてのマシンタイプ | 4,000

## PostgreSQL

+ 確認コマンド

```
SELECT * FROM pg_settings WHERE name = 'max_connections';
```

+ デフォルト接続上限

```
マシンタイプ構成設定により、選択したコア数に基づき、自動的に利用可能なメモリサイズの範囲が調整される
```
