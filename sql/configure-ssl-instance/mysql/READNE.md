# SSL/TLS 証明書の構成 | MySQL 編

## 概要

+ 公式ドキュメント
  + [SSL/TLS 証明書を使用して承認する](https://cloud.google.com/sql/docs/mysql/authorize-ssl)
  + [SSL/TLS 証明書の構成](https://cloud.google.com/sql/docs/mysql/configure-ssl-instance)


## やってみる

### Cloud SQL Instance の作成

+ 設定
  + [Cloud SQL | gcloud コマンド](../../gcloud/) 参照

```
export _gcp_pj_id='Your GCP Project ID'
export _region='asia-northeast1'

export _instance_name="sslcon-test-$(date +'%Y%m%d%H%M')"
export _instance_type='db-f1-micro'

export _mysql_ver='MYSQL_8_0'
export _mysql_root_passwd='password0123'

export _my_pub_ip='Your Public IP Address'
```

+ Instance 作成

```
gcloud beta sql instances create ${_instance_name} \
  --database-version ${_mysql_ver} \
  --root-password "${_mysql_root_passwd}" \
  --tier ${_instance_type} \
  --region ${_region} \
  --project ${_gcp_pj_id} \
  --async
```

+ SSL/TLS の使用を必須とする

```
gcloud sql instances patch ${_instance_name} \
  --require-ssl \
  --project ${_gcp_pj_id}
```

+ パブリック IP アドレスの承認済みネットワークを設定する
  + https://cloud.google.com/sql/docs/mysql/authorize-networks?hl=ja#gcloud

```
gcloud sql instances patch ${_instance_name} \
  --authorized-networks=${_my_pub_ip} \
  --project ${_gcp_pj_id}
```

### 新しいクライアント証明書を作成する

https://cloud.google.com/sql/docs/mysql/configure-ssl-instance#new-client

+ 新しいクライアント証明書を作成しクライアント証明書を作成する
  + `クライアント秘密鍵`

```
export _cert_name='sslcon-test'
```
```
gcloud sql ssl client-certs create ${_cert_name} ${_cert_name}-client-key.pem \
  --instance ${_instance_name} \
  --project ${_gcp_pj_id}
```

+ 作成した証明書の公開鍵をファイルにコピー
  + `クライアントの公開鍵証明書`

```
gcloud sql ssl client-certs describe ${_cert_name} \
  --instance ${_instance_name} \
  --project ${_gcp_pj_id} \
  --format="value(cert)" \
  > ${_cert_name}-client-cert.pem
```

+ サーバー証明書を server-ca.pem ファイルにコピー
  + `サーバー証明書`

```
gcloud sql instances describe ${_instance_name} \
  --project ${_gcp_pj_id} \
  --format="value(serverCaCert.cert)" \
  > ${_cert_name}-server-ca.pem
```



### 接続テスト


```
export _sql_ex_ip='Your Cloud SQL Instance External IP Addr'   # CLI で取れるはず
```


https://cloud.google.com/sql/docs/mysql/connect-admin-ip#connect-ssl

```
# mysql --version
mysql  Ver 8.0.30 for Linux on x86_64 (MySQL Community Server - GPL)
```

+ SSL 無し

```
# mysql --user root   --password
Enter password: 
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2)

---> エラーが分かりづらい...
```

+ SSL 有り

```
# mysql   --ssl-ca sslcon-test-server-ca.pem   --ssl-cert sslcon-test-client-cert.pem   --ssl-key sslcon-test-client-key.pem   --host 35.200.113.161   --ssl-mode verify_ca   --user root   --password
Enter password: 


Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 976
Server version: 8.0.26-google (Google)

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
mysql> exit
Bye
```

---> SSL/TLS のみで接続出来ました

## MySQL Workbentch から繋いで見る

OK


## リソースの削除


+ Instance 削除

```
gcloud beta sql instances delete ${_instance_name} \
  --project ${_gcp_pj_id} \
  --async
```