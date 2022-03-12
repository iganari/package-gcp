# gcloud コマンド


## 準備

```
export _gcp_pj_id='Your GCP Project ID'
export _sql_instance_name="cloudsql-test-$(date +'%Y%m%d%H%M')"
export _region='asia-northeast1'
export _instance_type='db-f1-micro'


echo ${_sql_instance_name}
```

+ 使用できるデータベースのリスト
  + https://cloud.google.com/sql/docs/mysql/admin-api/rest/v1beta4/SqlDatabaseVersion

+ GCP にログインする

```
gcloud auth login -q
```


## Cloud SQL instance を作成

+ MySQL
  + `root` ユーザがデフォルトで作成される
  + デフォルトのポートは `3306`

```
gcloud beta sql instances create ${_sql_instance_name} \
  --database-version MYSQL_8_0 \
  --root-password=password123 \
  --tier ${_instance_type} \
  --region ${_region} \
  --project ${_gcp_pj_id}
```

+ PostgreSQL
  + `postgres` ユーザがデフォルトで作成される
  + デフォルトのポートは `5432`

```
gcloud beta sql instances create ${_sql_instance_name} \
  --database-version POSTGRES_9_6 \
  --root-password=password123 \
  --tier ${_instance_type} \
  --region ${_region} \
  --project ${_gcp_pj_id}
```

## Cloud SQL instance を削除

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

