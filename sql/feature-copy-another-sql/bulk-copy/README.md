# Bulk Copy

## 概要

一括コピー






## やり方

### env

```
export _source_sql_instance_name='コピー元の Cloud SQL のインスタンス名'
export _source_sql_instance_project='コピー元の Cloud SQL のインスタンスがある Google Cloud Project ID'
export _source_sql_backup_region='バックアップデータの保存リージョン'


export _replica_sql_instance_name='コピー先の Cloud SQL のインスタンス名'
export _replica_sql_instance_project='コピ先の Cloud SQL のインスタンスがある Google Cloud Project ID'
```




Source の最新のバックアップ(オンデマンド)

```
gcloud beta sql backups create \
--async \
--instance=INSTANCE_NAME \
--location=BACKUP_LOCATION
```
