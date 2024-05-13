# Cloud SQL for PostgreSQL にサンプルのダミーデータ入れる

## 概要

Cloud SQL for PostgreSQL にダミーデータをいれるサンプルです

### 使用するダミーデータ

- PostgreSQL
  - https://www.postgresqltutorial.com/postgresql-getting-started/postgresql-sample-database/
  - https://www.postgresql.org/ftp/projects/pgFoundry/dbsamples/world/


## 1. Cloud SQL Instance の用意

+ [Cloud SQL の gcloud コマンド](../../_gcloud/) を参考に **Pubulic IP Address 付きの Cloud SQL Instance** の作成を行う

```
### Cloud SQL Instance の設定

export _gc_pj_id='Your Google Cloud Project ID'

export _common='pkg-gcp-sql-dummydata'
export _instance_type='db-g1-small'
export _region='asia-northeast1'

export _instance_name="$(echo ${_common})-$(date +'%Y%m%d%H%M')"
echo ${_instance_name}
```
```
export _mysql_ver='MYSQL_8_0'
export _mysql_root_passwd="$(echo ${_gc_pj_id})"
```
```
### データベースの設定

export _psgrs_ver='POSTGRES_15'
export _psgrs_passwd="$(echo ${_gc_pj_id})"
```

あとは、上記のリンクの [PostgreSQL の場合 | Public IP Address のみ](.././_gcloud/README.md#1-1-mysql-の場合) を実行する