# gcloud コマンド

## 0. 準備

+ GCP にログインする

```
gcloud auth login --no-launch-browser -q
```

+ API の有効化をする

```
gcloud beta services enable sqladmin.googleapis.com --project ${_gc_pj_id}
```

## 1. Cloud SQL Instance を作成

+ 環境変数に入れる
  + `_instance_type` -> 使用できるインスタンスタイプ : https://cloud.google.com/sql/docs/mysql/admin-api/rest/v1beta4/tiers/list
  + `_instance_name` -> Cloud SQL Instance の Name はユニークである必要があるため被らないような対策が必要

```
export _gc_pj_id='Your GCP Project ID'

export _common='pkg-gcp-sql-instance'
export _instance_type='db-g1-small'
export _region='asia-northeast1'

export _instance_name="$(echo ${_common})-$(date +'%Y%m%d%H%M')"
echo ${_instance_name}
```


### 1-1. MySQL の場合

+ MySQL 特有の設定をいれる
  + 使用できるデータベースのバージョン -> [SqlDatabaseVersion](https://cloud.google.com/sql/docs/mysql/admin-api/rest/v1beta4/SqlDatabaseVersion)

```
export _mysql_ver='MYSQL_8_0'
export _mysql_root_passwd="$(echo ${_gc_pj_id})"
```

+ gcloud コマンドを使って、 Cloud SQL Instance を作成する
  + `root` ユーザがデフォルトで作成される
  + デフォルトのポートは `3306`

```
### Public IP Address のみ
gcloud beta sql instances create ${_instance_name} \
  --database-version ${_mysql_ver} \
  --root-password "${_mysql_root_passwd}" \
  --tier ${_instance_type} \
  --region ${_region} \
  --project ${_gc_pj_id} \
  --async
```
```
### Public IP Address と Private IP Address
WIP
```
```
### Private IP Address のみ
WIP
```


### 1-2. PostgreSQL の場合

+ PostgreSQL 特有の設定を入れる
  + 使用できるデータベースのバージョン -> [SqlDatabaseVersion](https://cloud.google.com/sql/docs/mysql/admin-api/rest/v1beta4/SqlDatabaseVersion)

```
export _psgrs_ver='POSTGRES_15'
export _psgrs_passwd="$(echo ${_gc_pj_id})"
```

+ gcloud コマンドを使って、 Cloud SQL Instance を作成する
  + `postgres` ユーザがデフォルトで作成される
  + デフォルトのポートは `5432`

```
gcloud beta sql instances create ${_instance_name} \
  --edition enterprise \
  --database-version ${_psgrs_ver} \
  --root-password "${_psgrs_passwd}" \
  --tier ${_instance_type} \
  --region ${_region} \
  --no-backup \
  --storage-size 10G \
  --storage-auto-increase \
  --project ${_gc_pj_id} \
  --async
```

- Cloud SQL Instance の情報の確認

```
gcloud beta sql instances describe ${_instance_name} --project ${_gc_pj_id} --format json
```


## 2. Database の作成

+ 環境変数に入れる

```
export _database_name='pkg-gcp-sql-db'
export _database_character_set='utf8'
```
```
gcloud beta sql databases create ${_database_name} \
  --instance ${_instance_name} \
  --charset ${_database_character_set} \
  --project ${_gc_pj_id} \
  --async
```

```
gcloud beta sql databases
https://cloud.google.com/sdk/gcloud/reference/beta/sql/databases
```

## 3. User の作成

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
  --project ${_gc_pj_id} \
  --async
```

```
gcloud beta sql users
https://cloud.google.com/sdk/gcloud/reference/beta/sql/users

gcloud beta sql users create
https://cloud.google.com/sdk/gcloud/reference/beta/sql/users/create
```

## 4. Cloud SQL Auth Proxy を使用してログイン

```
WIP
```

## 5. Cloud SQL instance を再起動

```
WIP
```

## 6. Cloud SQL instance を停止

+ [gcloud beta sql instances patch](https://cloud.google.com/sdk/gcloud/reference/beta/sql/instances/patch?hl=en)

```
gcloud beta sql instances patch ${_sql_instance_name} \
  --activation-policy NEVER \
  --project ${_gc_pj_id}
```

## 7. Cloud SQL instance を停止状態から起動

+ [gcloud beta sql instances patch](https://cloud.google.com/sdk/gcloud/reference/beta/sql/instances/patch?hl=en)

```
gcloud beta sql instances patch ${_sql_instance_name} \
  --activation-policy ALWAYS \
  --project ${_gc_pj_id}
```

## 8. Cloud SQL Instance を削除

```
gcloud beta sql instances delete ${_sql_instance_name}  \
  --project ${_gc_pj_id} \
  -q
```

## 9. 非同期ジョブにする

+ `--async` をつける

```
gcloud beta sql instances patch ${_sql_instance_name} \
  --activation-policy NEVER \
  --async \
  --project ${_gc_pj_id}
```

+ 非同期にした job のリストを確認する
  + https://cloud.google.com/sdk/gcloud/reference/sql/operations/list 


```
gcloud beta sql operations list ${_sql_instance_name} --project ${_gc_pj_id} 
```
```
### 例

$ gcloud beta sql operations list ${_sql_instance_name} --project ${_gc_pj_id}
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

$ gcloud beta sql operations wait --project ${_gc_pj_id} {operation name} --timeout=unlimited
Waiting for [https://sqladmin.googleapis.com/sql/v1beta4/projects/_your_gcp_pj_id/operations/4503f367-e7b6-48e6-88c6-1e120000002b]...done.                                                                                       
NAME                                  TYPE    START                          END                            ERROR  STATUS
4503f367-e7b6-48e6-88c6-1e120000002b  UPDATE  2022-04-24T07:07:30.519+00:00  2022-04-24T07:19:01.768+00:00  -      DONE

$
```


## オンデマンドのバックアップを作成・確認

### バックアップの作成

```
export _gc_pj_id='Your Google Cloud Project'
export _sql_instance_name='Your Cloud SQL Instance Name'
export _bk_location='Back Up Locatoin'  ### asia-northeast1
```
```
gcloud beta sql backups create \
  --instance ${_sql_instance_name} \
  --location ${_bk_location} \
  --description="On-demand Backup" \
  --project ${_gc_pj_id} \
  --async
```


### バックアップの確認

```
gcloud beta sql backups list \
  --instance ${_sql_instance_name} \
  --project ${_gc_pj_id} \
  --format json | jq .[].id
```

```
### 例

$ gcloud beta sql backups list \
  --instance ${_sql_instance_name} \
  --project ${_gc_pj_id} \
  --format json | jq .[].id
"1740587222425"
"1740499200000"
"1740412800000"
"1740326400000"
"1740240000000"
"1740153600000"
"1740067200000"
"1739980800000"
"1736390505693"
"1736389368958"
"1732254091937"
"1729535028699"
"1709143958865"
"1688129311577"
"1683006593196"
"1594624477205"
"1574436199564"
"1567563873797"
"1559755678953"
"1517582134388"
```

### 最新の ID を指定して、バックアップの内容を確認する

- 基本コマンド

```
gcloud beta sql backups list \
  --instance ${_sql_instance_name} \
  --project ${_gc_pj_id} \
  --format json | jq -r '.[] | select(.id == "<backupID>")'
```

- 組み合わせて、最新の ID を指定して、バックアップの内容を確認する

```
export _latest_id=$(gcloud beta sql backups list \
  --instance ${_sql_instance_name} \
  --project ${_gc_pj_id} \
  --format json | jq -r .[].id | head -1)

echo ${_latest_id}
```
```
jq ...

gcloud beta sql backups list \
  --instance ${_sql_instance_name} \
  --project ${_gc_pj_id} \
  --format json | jq -r '.[] | select(.id == \"${_latest_id}\")'
としたいが、${_latest_id} が入らない...
```

