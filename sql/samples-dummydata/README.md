# Cloud SQL Instance にサンプルのダミーデータをいれる

## 概要

Cloud SQL Instance にサンプルのダミーデータをいれる工程を記す

MySQL, PostgreSQL, SQL Server のバージョンを記しておく

### 使用するダミーデータ

+ MySQl
  + https://github.com/iganari/code-labo/tree/main/mysql
  + https://dev.mysql.com/doc/index-other.html

## 1. Cloud SQL for MySQL の場合

### 1-1. Cloud SQL Instance の用意

+ [Cloud SQL の gcloud コマンド](../_gcloud/) を参考に **Pubulic IP Address 付きの Cloud SQL Instance** の作成を行う

```
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

あとは、上記のリンクの [MySQL の場合 | Public IP Address のみ](../_gcloud/README.md#1-1-mysql-の場合) を実行する


+ 確認する

```
gcloud beta sql instances list --project ${_gc_pj_id}
```
```
### 例

$ gcloud beta sql instances list --project ${_gc_pj_id}
NAME                                DATABASE_VERSION  LOCATION           TIER         PRIMARY_ADDRESS  PRIVATE_ADDRESS  STATUS
pkg-gcp-sql-dummydata-202305240830  MYSQL_8_0         asia-northeast1-b  db-g1-small  35.200.31.48     -                RUNNABLE
```

### 1-2. サンプルデータの用意

+ サンプルデータを公式 URL からダウンロード
  + https://dev.mysql.com/doc/index-other.html

```
cd { Your Workspace }

wget https://downloads.mysql.com/docs/world-db.zip
wget https://downloads.mysql.com/docs/world_x-db.zip

unzip world-db.zip
unzip world_x-db.zip
```

+ データの確認

```
$ ls -lh
total 200K
drwxr-xr-x 2 iganari iganari 4.0K May  1 08:35 world-db/
-rw-rw-r-- 1 iganari iganari  91K May  1 08:35 world-db.zip
drwxr-xr-x 2 iganari iganari 4.0K May  1 08:35 world_x-db/
-rw-rw-r-- 1 iganari iganari  98K May  1 08:35 world_x-db.zip
```
```
$ du -sh world-db
396K    world-db
```
```
$ du -sh world_x-db
556K    world_x-db
```

+ Google Cloud Storage の Bucket を作成する

```
gcloud storage buckets create gs://${_gc_pj_id}-${_common} \
  --default-storage-class standard \
  --location ${_region} \
  --project ${_gc_pj_id}
```

+ Google Cloud Storage にアップロードする

```
gcloud storage cp world-db/world.sql gs://${_gc_pj_id}-${_common}/
gcloud storage cp world_x-db/world_x.sql gs://${_gc_pj_id}-${_common}/
```

### 1-3. Cloud SQL Instance の Service Account の Role を設定

+ SQL instance の SA を確認

```
gcloud sql instances describe ${_instance_name} --project ${_gc_pj_id} --format json | jq -r .serviceAccountEmailAddress

export _sql_instance_sa="$(gcloud sql instances describe ${_instance_name} --project ${_gc_pj_id} --format json | jq -r .serviceAccountEmailAddress)"
```
```
$ echo ${_sql_instance_sa}
pxxxxxxxxxxxx-ewynhm@gcp-sa-cloud-sql.iam.gserviceaccount.com
```

+ Cloud SQL Instance が Cloud Storage を読めるようにする
  + `Storage Object Viewer` **roles/storage.objectViewer**
  + `Viewer` **roles/viewer**
  + `Storage Admin` **roles/storage.admin**

```
gcloud beta projects add-iam-policy-binding ${_gc_pj_id} \
  --member="serviceAccount:${_sql_instance_sa}" \
  --role="roles/storage.objectViewer"
```

### 1-4. Cloud Storage から Cloud SQL Instance にサンプルデータを挿入( Import )する

+ gcloud コマンドを使って挿入( Import )する

```
### world.sql
gcloud beta sql import sql ${_instance_name} gs://${_gc_pj_id}-${_common}/world.sql --project ${_gc_pj_id}

### world_x.sql
gcloud beta sql import sql ${_instance_name} gs://${_gc_pj_id}-${_common}/world_x.sql --project ${_gc_pj_id}
```

+ Cloud SQL Instance 内の Database を確認する

```
gcloud sql databases list --instance ${_instance_name} --project ${_gc_pj_id}
```
```
### 例

$ gcloud sql databases list --instance ${_instance_name} --project ${_gc_pj_id}
NAME                CHARSET  COLLATION
mysql               utf8     utf8_general_ci
information_schema  utf8     utf8_general_ci
performance_schema  utf8mb4  utf8mb4_0900_ai_ci
sys                 utf8mb4  utf8mb4_0900_ai_ci
world               utf8mb4  utf8mb4_0900_ai_ci
world_x             utf8mb4  utf8mb4_0900_ai_ci
```

### 1-5. Cloud SQL Instance 内のサンプルデータを確認する

+ Cloud SQL Instance 内の user 作る

```
gcloud beta sql users create iganari \
  --instance ${_instance_name} \
  --password=${_gc_pj_id} \
  --project ${_gc_pj_id}
```

+ gcloud 経由で Cloud SQL Instance に繋ぐ
  + :warning:
    + 実行環境に mysql コマンドが必要
    + Public IP Address の Auth Network は自動で作ってくれる
    + **gcloud beta sql** コマンドは敢えて使っていない

```
gcloud sql connect ${_instance_name} \
  --user iganari \
  --project ${_gc_pj_id}
```
```
### 例

$ gcloud sql connect ${_instance_name} \
  --user iganari \
  --project ${_gc_pj_id}
Allowlisting your IP for incoming connection for 5 minutes...done.                                                                                                                                                             
Connecting to database with SQL user [iganari].Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 486
Server version: 8.0.26-google (Google)

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> 
```

+ Cloud SQL Instance 内の Database を確認する

```
MySQL [(none)]> SHOW DATABASES ;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| world              |
| world_x            |
+--------------------+
6 rows in set (0.005 sec)

MySQL [(none)]> 
```

+ Cloud SQL Instance 内の Table を確認する

```
MySQL [(none)]> SHOW TABLES FROM world ;
+-----------------+
| Tables_in_world |
+-----------------+
| city            |
| country         |
| countrylanguage |
+-----------------+
3 rows in set (0.005 sec)

MySQL [(none)]>
```
```
MySQL [(none)]> SHOW TABLES FROM world_x ;
+-------------------+
| Tables_in_world_x |
+-------------------+
| city              |
| country           |
| countryinfo       |
| countrylanguage   |
+-------------------+
4 rows in set (0.004 sec)

MySQL [(none)]> 
```

+ その他のサンプルクエリ

```
SELECT * FROM world.city ;
```
```
SELECT * FROM world_x.countryinfo ;
```

+ Cloud SQL Instance からログアウトする

```
exit
```
```
### 例

MySQL [(none)]> exit
Bye
```
