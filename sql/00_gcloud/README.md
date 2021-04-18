# gcloud コマンド


## 準備

```
export _gcp_id='Your GCP Project ID'
export _sql_instance_name="cloudsql-test-$(date +'%Y%m%d%H%M')"



echo ${_sql_instance_name}
```

## Cloud SQL instance を作成

+ MySQL

```
gcloud beta sql instances create [Instance Name] \
  --database-version MYSQL_8_0 \
  --root-password=password123 \
  --tier db-f1-micro \
  --region [Your Region] \
  --project [GCP Project ID]
```

+ PostgreSQL

```
gcloud beta sql instances create [Instance Name] \
  --database-version POSTGRES_9_6 \
  --root-password=password123 \
  --tier db-f1-micro \
  --region [Your Region] \
  --project [GCP Project ID]
```

## Cloud SQL instance を削除

```
WIP
```

## ## Cloud SQL instance を再起動

```
WIP
```

## Cloud SQL instance を停止

+ [gcloud beta sql instances patch](https://cloud.google.com/sdk/gcloud/reference/beta/sql/instances/patch?hl=en)

```
gcloud beta sql instances patch ${_sql_instance_name} \
    --activation-policy NEVER \
    --project ${_gcp_id}
```

## Cloud SQL instance を停止状態から起動

+ [gcloud beta sql instances patch](https://cloud.google.com/sdk/gcloud/reference/beta/sql/instances/patch?hl=en)

```
gcloud beta sql instances patch ${_sql_instance_name} \
    --activation-policy ALWAYS \
    --project ${_gcp_id}
```

