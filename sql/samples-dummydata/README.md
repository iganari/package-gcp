# ダミーデータを入れる

## 概要

hogehoge

使用するダミーデータ

https://github.com/iganari/code-labo/tree/main/mysql



## Cloud SQL Instance の用意

```
cd { Your Workspace }

wget https://downloads.mysql.com/docs/world-db.zip
wget https://downloads.mysql.com/docs/world_x-db.zip

unzip world-db.zip
unzip world_x-db.zip
```

```
$ ls -lh
total 200K
drwxr-xr-x 2 iganari iganari 4.0K May  1 07:05 world-db/
-rw-rw-r-- 1 iganari iganari  91K May  1 07:05 world-db.zip
drwxr-xr-x 2 iganari iganari 4.0K May  1 07:05 world_x-db/
-rw-rw-r-- 1 iganari iganari  98K May  1 07:05 world_x-db.zip
```
```
$ du -sh world-db
396K    world-db
```
```
$ du -sh world_x-db
556K    world_x-db
```

+ 環境変数

```
export _gc_pj_id='ca-igarashi-test-2023q2'
```

+ gcs にupload

```
gcloud storage buckets create gs://${_gc_pj_id}-my-bucket \
  --default-storage-class standard \
  --location asia-northeast1 \
  --project ${_gc_pj_id}
```
```
gcloud storage cp world-db/world.sql gs://${_gc_pj_id}-my-bucket/
gcloud storage cp world_x-db/world_x.sql gs://${_gc_pj_id}-my-bucket/
```

+ SQL instance の SA を確認

```
gcloud sql instances describe check-01 --project ${_gc_pj_id} --format json | jq -r .serviceAccountEmailAddress
```
```
$ gcloud sql instances describe check-01 --project ${_gc_pj_id} --format json | jq -r .serviceAccountEmailAddress
p140009665765-mgwf5b@gcp-sa-cloud-sql.iam.gserviceaccount.com
```

+ SQL Instance が GCS を読めるようにする
  + `Storage Object Viewer` **roles/storage.objectViewer**
  + `Viewer` **roles/viewer**
  + `Storage Admin` **roles/storage.admin**

```
gcloud beta projects add-iam-policy-binding ${_gc_pj_id} \
  --member="serviceAccount:p140009665765-mgwf5b@gcp-sa-cloud-sql.iam.gserviceaccount.com" \
  --role="roles/storage.objectViewer"
```
```
gcloud beta projects add-iam-policy-binding ${_gc_pj_id} \
  --member="serviceAccount:p140009665765-mgwf5b@gcp-sa-cloud-sql.iam.gserviceaccount.com" \
  --role="roles/viewer"
```
```
gcloud beta projects add-iam-policy-binding ${_gc_pj_id} \
  --member="serviceAccount:p140009665765-mgwf5b@gcp-sa-cloud-sql.iam.gserviceaccount.com" \
  --role="roles/storage.admin"
```




```
gcloud beta sql import sql check-01 gs://${_gc_pj_id}-my-bucket/world.sql \
  --project ${_gc_pj_id}
```
```
gcloud beta sql import sql check-01 gs://${_gc_pj_id}-my-bucket/world_x.sql \
  --project ${_gc_pj_id}
```

+ user 作る

```
gcloud beta sql users create iganari \
  --instance check-01 \
  --password=${_gc_pj_id} \
  --project ${_gc_pj_id}
```

+ sql instance に繋ぐ
  + mysql コマンドが必要
  + Public IP Address が必要( auth network は自動で作ってくれる )

```
gcloud sql connect check-01 \
  --user iganari \
  --project ${_gc_pj_id}
```

```
MySQL [(none)]> show databases ;
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

+ select

```
SELECT * FROM world.city ;
```
```
SELECT * FROM world_x.countryinfo ;
```



```
SHOW TABLES FROM world_x ;
```

---> 見れた

+ ぬける

```
MySQL [(none)]> exit
Bye
```

+ network 確認

```
gcloud beta sql instances describe check-01 --project ${_gc_pj_id} --format json | jq .settings.ipConfiguration.authorizedNetworks[]
```
```
$ gcloud beta sql instances describe check-01 --project ${_gc_pj_id} --format json | jq .settings.ipConfiguration.authorizedNetworks[]
{
  "kind": "sql#aclEntry",
  "name": "sql connect at time 2023-05-18 02:20:22.525756+00:00",
  "value": "34.84.146.186"
}
```


+ authorized-networks を全削除する

```
gcloud sql instances patch check-01 \
  --clear-authorized-networks \
  --project ${_gc_pj_id}

```
$ gcloud beta sql instances describe check-01 --project ${_gc_pj_id} --format json | jq .settings.ipConfiguration
{
  "enablePrivatePathForGoogleCloudServices": true,
  "ipv4Enabled": true,
  "privateNetwork": "projects/ca-igarashi-test-2023q2/global/networks/check-vpc"
}
```

## BQ

https://cloud.google.com/bigquery/docs/cloud-sql-federated-queries
https://qiita.com/Shmwa2/items/e15c97db48ef278e956b



1. 手動でexternal connections をつくる

--> Connection ID = projects/ca-igarashi-test-2023q2/locations/asia-northeast1/connections/hogehogehoge

--> 個別の SA 出来る ---> 
Role
Cloud SQL Client をつける


2. BQ sql

```
-- List all tables in a database.
SELECT * FROM EXTERNAL_QUERY("projects/ca-igarashi-test-2023q2/locations/asia-northeast1/connections/hogehogehoge",
"select * from information_schema.columns where table_name='x';");

---> no data
```

```
SELECT * FROM EXTERNAL_QUERY("ca-igarashi-test-2023q2.asia-northeast1.hogehogehoge", "SHOW TABLES FROM world;");


---> これはできた
```

米
pribate アクセスをとった時にちゃんと繋がらなくなることを見る