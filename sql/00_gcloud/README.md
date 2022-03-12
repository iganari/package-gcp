# gcloud コマンド


## 準備

```
export _gcp_pj_id='Your GCP Project ID'
export _region='asia-northeast1'

export _instance_name="pkg-gcp-sql-instance-$(date +'%Y%m%d%H%M')"
export _instance_type='db-f1-micro'

export _database_name='pkg-gcp-sql-db'
export _database_character_set='utf8'



echo ${_sql_instance_name}
```

+ 使用できるデータベースのリスト
  + https://cloud.google.com/sql/docs/mysql/admin-api/rest/v1beta4/SqlDatabaseVersion

+ GCP にログインする

```
gcloud auth login -q
```


## Cloud SQL Instance を作成

+ MySQL
  + `root` ユーザがデフォルトで作成される
  + デフォルトのポートは `3306`

```
gcloud beta sql instances create ${_instance_name} \
  --database-version MYSQL_8_0 \
  --root-password=password123 \
  --tier ${_instance_type} \
  --region ${_region} \
  --project ${_gcp_pj_id} \
  --async
```

+ PostgreSQL
  + `postgres` ユーザがデフォルトで作成される
  + デフォルトのポートは `5432`

```
gcloud beta sql instances create ${_instance_name} \
  --database-version POSTGRES_9_6 \
  --root-password=password123 \
  --tier ${_instance_type} \
  --region ${_sql_region} \
  --project ${_gcp_pj_id} \
  --async
```

## Database の作成

```
gcloud sql databases create ${_database_name} \
  --instance ${_instance_name} \
  --charset ${_database_character_set} \
  --async
```

## Cloud SQL Instance を削除

```
gcloud beta sql instances delete ${_sql_instance_name}  \
  --project ${_gcp_pj_id} \
  -q
```

## Cloud SQL instance を再起動

```
WIP
```

## Cloud SQL instance を停止

+ [gcloud beta sql instances patch](https://cloud.google.com/sdk/gcloud/reference/beta/sql/instances/patch?hl=en)

```
gcloud beta sql instances patch ${_sql_instance_name} \
    --activation-policy NEVER \
    --project ${_gcp_pj_id}
```

## Cloud SQL instance を停止状態から起動

+ [gcloud beta sql instances patch](https://cloud.google.com/sdk/gcloud/reference/beta/sql/instances/patch?hl=en)

```
gcloud beta sql instances patch ${_sql_instance_name} \
    --activation-policy ALWAYS \
    --project ${_gcp_pj_id}
```

