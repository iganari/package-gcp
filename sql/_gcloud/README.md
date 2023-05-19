# gcloud コマンド


## 準備

+ 環境変数に入れる

```
export _gcp_pj_id='Your GCP Project ID'
export _region='asia-northeast1'
```

+ 使用できるデータベースのリスト
  + https://cloud.google.com/sql/docs/mysql/admin-api/rest/v1beta4/SqlDatabaseVersion

+ GCP にログインする

```
gcloud auth login --no-launch-browser -q
```

+ API の有効化をする

```
gcloud beta services enable sqladmin.googleapis.com --project ${_gcp_pj_id}
```

## Cloud SQL Instance を作成

+ 環境変数に入れる

```
export _instance_name="pkg-gcp-sql-instance-$(date +'%Y%m%d%H%M')"
export _instance_type='db-f1-micro'

echo ${_sql_instance_name}
```


### MySQL の場合

+ `root` ユーザがデフォルトで作成される
+ デフォルトのポートは `3306`
+ 使用できるデータベースのバージョン -> [SqlDatabaseVersion](https://cloud.google.com/sql/docs/mysql/admin-api/rest/v1beta4/SqlDatabaseVersion)

```
export _mysql_ver='MYSQL_8_0'
export _mysql_root_passwd='password0123'
```
```
gcloud beta sql instances create ${_instance_name} \
  --database-version ${_mysql_ver} \
  --root-password "${_mysql_root_passwd}" \
  --tier ${_instance_type} \
  --region ${_region} \
  --project ${_gcp_pj_id} \
  --async
```

### PostgreSQL の場合

+ `postgres` ユーザがデフォルトで作成される
+ デフォルトのポートは `5432`
+ 使用できるデータベースのバージョン -> [SqlDatabaseVersion](https://cloud.google.com/sql/docs/mysql/admin-api/rest/v1beta4/SqlDatabaseVersion)

```
export _psgr_ver='POSTGRES_14'
export _psgr_passwd='password9876'
```
```
gcloud beta sql instances create ${_instance_name} \
  --database-version ${_psgr_ver} \
  --root-password "${_psgr_passwd}" \
  --tier ${_instance_type} \
  --region ${_sql_region} \
  --project ${_gcp_pj_id} \
  --async
```

## Database の作成

+ 環境変数に入れる

```
export _database_name='pkg-gcp-sql-db'
export _database_character_set='utf8'
```
```
gcloud beta sql databases create ${_database_name} \
  --instance ${_instance_name} \
  --charset ${_database_character_set} \
  --project ${_gcp_pj_id} \
  --async
```

```
gcloud beta sql databases
https://cloud.google.com/sdk/gcloud/reference/beta/sql/databases
```

## User の作成

+ 環境変数に入れる

```
export _user_name='iganari'
export _user_passwd='0123456789abcsd'
```
```
gcloud beta sql users create ${_user_name} \
  --password ${_user_passwd} \
  --host "%" \
  --instance ${_instance_name} \
  --project ${_gcp_pj_id} \
  --async
```

```
gcloud beta sql users
https://cloud.google.com/sdk/gcloud/reference/beta/sql/users

gcloud beta sql users create
https://cloud.google.com/sdk/gcloud/reference/beta/sql/users/create
```

## Cloud SQL Auth Proxy を使用してログイン

```
WIP
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

## Cloud SQL Instance を削除

```
gcloud beta sql instances delete ${_sql_instance_name}  \
  --project ${_gcp_pj_id} \
  -q
```

## 非同期ジョブにする

+ `--async` をつける

```
gcloud beta sql instances patch ${_sql_instance_name} \
  --activation-policy NEVER \
  --async \
  --project ${_gcp_pj_id}
```

+ 非同期にした job のリストを確認する
  + https://cloud.google.com/sdk/gcloud/reference/sql/operations/list 


```
gcloud beta sql operations list ${_sql_instance_name} --project ${_gcp_pj_id} 
```
```
### 例

$ gcloud beta sql operations list ${_sql_instance_name} --project ${_gcp_pj_id}  
NAME                                  TYPE             START                          END                            ERROR  STATUS
4503f367-e7b6-48e6-88c6-1e120000002b  UPDATE           2022-04-24T07:07:30.519+00:00  T                              -      RUNNING
ac90dc58-d272-4f1e-bc90-ae990000002b  UPDATE           2022-04-24T07:03:34.453+00:00  2022-04-24T07:04:10.679+00:00  -      DONE
872b8b05-4729-4433-8a83-43e80000002b  UPDATE           2022-04-24T06:38:01.752+00:00  2022-04-24T06:50:31.671+00:00  -      DONE
```

+ 非同期にした特定の job の状態を見る
  + https://cloud.google.com/sdk/gcloud/reference/sql/operations/wait

```
gcloud beta sql operations wait --project cmg-pyxis2v2-dev {operation name}

OR

gcloud beta sql operations wait --project cmg-pyxis2v2-dev {operation name} --timeout=unlimited
```
```
### 例

$ gcloud beta sql operations wait --project cmg-pyxis2v2-dev {operation name} --timeout=unlimited
Waiting for [https://sqladmin.googleapis.com/sql/v1beta4/projects/_your_gcp_pj_id/operations/4503f367-e7b6-48e6-88c6-1e120000002b]...done.                                                                                       
NAME                                  TYPE    START                          END                            ERROR  STATUS
4503f367-e7b6-48e6-88c6-1e120000002b  UPDATE  2022-04-24T07:07:30.519+00:00  2022-04-24T07:19:01.768+00:00  -      DONE

$
```
