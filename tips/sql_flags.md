# Tips: CloudSQL for MySQL におけるパラメータを変更したい時

## 手段

flags 機能を使うことで、MySQL のパラメータなどを変更できる

+ flags のドキュメント
  + https://cloud.google.com/sql/docs/mysql/flags
+ 変更可能な flags の一覧
  + https://cloud.google.com/sql/docs/mysql/flags#list-flags

## 注意点

+ flags によっては、CloudSQL のインスタンスの可用性や安定性に影響を及ぼし、SLA 対象外になる可能性があるので注意
  + https://cloud.google.com/sql/docs/mysql/operational-guidelines
  
## コマンド例

+ gcloud

```
gcloud sql instances patch [INSTANCE_NAME] --database-flags [FLAG1=VALUE1,FLAG2=VALUE2]
```
```
### ex

gcloud sql instances patch iganari-instance \
    --database-flags [FLAG1=VALUE1,FLAG2=VALUE2]
```

+ 参考
  + https://cloud.google.com/sql/docs/mysql/flags#clearing_all_flags_to_their_default_value

## 実施例

CloudSQL にログイン後 (Cloud SQL Proxy などを用いて)

+ 確認

```

WIP
```

+ 注意
  + 再起動が必要なflagsに関しては勝手に再起動が走る

