# IAP to Cloud SQL for MySQL through GCE

[WIP] 内容的には出来ているが、文章の構成を修正する必要がある

やること

1. IAP -> GCE をまずは作る
1. 上記で作成した VPC ネットワークにピアリングした Cloud SQL を作成
1. GCE に Cloud SQL Auth Proxy を起動
1. 疎通確認

## IAP to GCE

https://github.com/iganari/package-gcp/tree/main/compute/iap/linux

```
### GitLab 用の環境変数

export _gcp_pj_id='Your GCP Project ID'
export _common='iap-gce-cloudsql-linux'
export _region='asia-northeast1'
export _zone='asia-northeast1-c'
export _your_gcp_email='Your GCP Email'
```

## Cloud SQL 作成

プライベート IP アドレスのみ

+ VPC ネットワークでプライベート サービス アクセスを構成する

```
### IP アドレス範囲を割り振る
gcloud beta compute addresses create google-managed-services-${_common}-network \
    --global \
    --purpose "VPC_PEERING" \
    --prefix-length 16 \
    --network ${_common}-network \
    --project ${_gcp_pj_id}


### プライベート接続の作成
gcloud beta services vpc-peerings connect \
    --service servicenetworking.googleapis.com \
    --ranges google-managed-services-${_common}-network \
    --network ${_common}-network \
    --project ${_gcp_pj_id}
```

+ Cloud SQL 作成する
  + Cloud SQL の名前の性質上、 `-2021` を付与

```
gcloud beta sql instances create ${_common}-2021 \
    --network ${_common}-network \
    --no-assign-ip \
    --database-version MYSQL_8_0 \
    --root-password=password123 \
    --tier db-f1-micro \
    --region ${_region} \
    --project ${_gcp_pj_id}
```

+ Cloud SQL のプライベートIPアドレスを調べておく


```
gcloud beta sql instances describe ${_common}-2021 --project ${_gcp_pj_id} --format json | jq .ipAddresses[]
```

```
### 例

# gcloud beta sql instances describe ${_common}-2021 --project ${_gcp_pj_id} --format json | jq .ipAddresses[]
{
  "ipAddress": "10.233.0.5",
  "type": "PRIVATE"
}
```

---> `10.233.0.5` はメモっておきます

## 疎通確認 GCE to Cloud SQL


+ SSH ログイン

```
gcloud beta compute ssh ${_common}-vm --zone ${_zone} --project ${_gcp_pj_id}
```

+ mysql コマンドをインストール

```
apt update
apt install mariadb-client -y
```

+ Cloud SQL のプライベート IP アドレスを環境変数に入れる

```
export cloudsql_ip_pri='10.233.0.5'
```


+ Cloud SQL にプライベート IP アドレス経由でログイン確認

```
mysql -h ${cloudsql_ip_pri} -u root -p
```
```
### 例

# mysql -h ${cloudsql_ip_pri} -u root -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 53
Server version: 8.0.18-google (Google)

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]>
MySQL [(none)]>
MySQL [(none)]> exit
Bye
```

---> Cloud SQL にプライベートIPアドレス経由で接続することが出来ました

一度 GCE からログアウトします

```
exit
```


## IAM

Cloud SQL Auth Proxy 用の Service Account を作成する

+ Service Account の作成

```
gcloud beta iam service-accounts create ${_common} \
    --description "ref: https://github.com/iganari/package-gcp" \
    --project ${_gcp_pj_id}
```

+ Email の確認
  + jq コマンドを使う
  + ここだけ `_common` の中を直打ちしています

```
gcloud beta iam service-accounts list --project ${_gcp_pj_id} --format json | jq -r '.[] | select(.name|test("iap-gce-cloudsql-linux")) | .email'
```
```
### 例

# gcloud beta iam service-accounts list --project ${_gcp_pj_id} --format json | jq -r '.[] | select(.name|test("iap-gce-cloudsql-linux")) | .email'
iap-gce-cloudsql-linux@[your_gcp_project_id].iam.gserviceaccount.com
```

+ role の付与
  + https://cloud.google.com/sql/docs/mysql/roles-and-permissions?hl=en#proxy-roles-permissions

```
export _proxy_sa_email=$(gcloud beta iam service-accounts list --project ${_gcp_pj_id} --format json | jq -r '.[] | select(.name|test("iap-gce-cloudsql-linux")) | .email')



gcloud beta projects add-iam-policy-binding ${_gcp_pj_id} \
    --member=serviceAccount:${_proxy_sa_email} \
    --role=roles/cloudsql.admin
```

+ Service Account の Key の作成とダウンロード

```
gcloud beta iam service-accounts keys create ${_common}_sa_key \
  --iam-account ${_proxy_sa_email} \
  --key-file-type=json \
  --project ${_gcp_pj_id}
```

+ 確認

```
ls | grep ${_common}_sa_key
```
```
### 例

# ls | grep ${_common}_sa_key
iap-gce-cloudsql-linux_sa_key
```

+ Service Account の Key を VM にアップロードする

```
gcloud beta compute scp ${_common}_sa_key ${_common}-vm:/var/tmp/ --zone ${_zone} --project ${_gcp_pj_id}
```

+ SSH ログインして Key の確認

```
gcloud beta compute ssh ${_common}-vm --zone ${_zone} --project ${_gcp_pj_id}
```
```
ls /var/tmp/ | grep _sa_key
```
```
### 例

# ls /var/tmp/ | grep _sa_key
iap-gce-cloudsql-linux_sa_key
```

---> Service Account の Key を転送出来た

このまま VM で作業します

## Cloud SQL Auth Proxy を起動

Cloud SQL Auth Proxy の常時起動を設定

+ Cloud SQL Auth Proxy をインストール
  + https://cloud.google.com/sql/docs/mysql/connect-admin-proxy#linux-64-bit

```
cd /usr/local/bin
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
chmod +x cloud_sql_proxy
```

+ Key も移動する

```
mv /var/tmp/$(ls /var/tmp | grep ${_common}_sa_key) /usr/local/bin
```

+ 確認

```
ls
```
```
### 例

# ls
cloud_sql_proxy  iap-gce-cloudsql-linux_sa_key
```

+ 接続出来るか確認
  + https://cloud.google.com/sql/docs/mysql/connect-admin-proxy#start-proxy

+ Cloud SQL の Connection name は以下のような名前になる
  + 故に予め設定しておく

```
${PROJECT_ID}:${REGION}:${INSTANCE_NAME}
```

```
### 環境変数

export _gcp_pj_id='Your GCP Project ID'
export _common='iap-gce-cloudsql-linux'
export _region='asia-northeast1'
export _zone='asia-northeast1-c'

export _con_name="${_gcp_pj_id}:${_region}:${_common}-2021"
```

+ `cloud_sql_proxy` を実行してみる

```
/usr/local/bin/cloud_sql_proxy -instances=${_con_name}=tcp:0.0.0.0:3306 -credential_file=/usr/local/bin/iap-gce-cloudsql-linux_sa_key &
```
```
# ps aufx | grep proxy
root        7282  3.0  2.8 714396 16540 pts/0    Sl   07:30   0:00          \_ /usr/local/bin/cloud_sql_proxy -instances=[your_gcp_project_id]:asia-northeast1:iap-gce-cloudsql-linux-2021=tcp:0.0.0.0:3306 -credential_file=/usr/local/bin/iap-gce-cloudsql-linux_sa_key
root        7288  0.0  0.1   5168   820 pts/0    S+   07:30   0:00          \_ grep --color=auto proxy
```

```
mysql -h 0.0.0.0 -u root -p
```
```
password123
```
```
### 例

# mysql -h 0.0.0.0 -u root -p
Enter password:
2021/04/08 07:32:40 New connection for "[your_gcp_project_id]:asia-northeast1:iap-gce-cloudsql-linux-2021"
2021/04/08 07:32:40 refreshing ephemeral certificate for instance [your_gcp_project_id]:asia-northeast1:iap-gce-cloudsql-linux-2021
2021/04/08 07:32:40 Scheduling refresh of ephemeral certifcate in 54m59.537894814s
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 837
Server version: 8.0.18-google (Google)

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> exit
2021/04/08 07:32:42 Client closed local connection on 127.0.0.1:3306
Bye
```

---> 出来た


+ 一旦プロセスをキルする

```
ps aufx | grep cloud_sql_proxy | grep -v "grep" | awk '{print $2}' | xargs kill -9
```


+ systemd による永続化の設定をする
  + https://cloud.google.com/sql/docs/mysql/sql-proxy#persistent-service

+ 設定ファイルを `/usr/local/bin/my_cloudsql.conf` に作る
  + あまり良くない PATH なので、適宜変更して下さい

```
cat << __EOF__ > /usr/local/bin/my_cloudsql.conf

PROJECT_ID="${_gcp_pj_id}"
REGION="${_region}"
INSTANCE_NAME="${_common}-2021"
PORT="3306"

__EOF__
```

+ `/etc/systemd/system/cloud_sql_proxy.service` に以下のファイルを作る
  + `EnvironmentFile` はあまり良くない PATH なので、適宜変更して下さい

```
[Unit]
Description = CloudSQL Proxy
After = network.target

[Service]
EnvironmentFile = /usr/local/bin/my_cloudsql.conf
ExecStart = /usr/local/bin/cloud_sql_proxy -instances=${PROJECT_ID}:${REGION}:${INSTANCE_NAME}=tcp:0.0.0.0:3306 -credential_file=/usr/local/bin/iap-gce-cloudsql-linux_sa_key
ExecStop = /bin/kill ${MAINPID}
ExecReload = /bin/kill -HUP ${MAINPID}
Restart = always
Type = simple

[Install]
WantedBy = multi-user.target
```

+ 権限変更

```
chmod 0644 /etc/systemd/system/cloud_sql_proxy.service
chmod 0644 /usr/local/bin/my_cloudsql.conf
```

+ 起動

```
systemctl start cloud_sql_proxy.service
```

+ 自動起動の設定

```
systemctl enable cloud_sql_proxy.service
```


+ 確認

```
systemctl status cloud_sql_proxy.service
```
```
### 例

# systemctl status cloud_sql_proxy.service
● cloud_sql_proxy.service - CloudSQL Proxy
     Loaded: loaded (/etc/systemd/system/cloud_sql_proxy.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2021-04-08 08:56:26 UTC; 30s ago
   Main PID: 7872 (cloud_sql_proxy)
      Tasks: 6 (limit: 677)
     Memory: 19.1M
     CGroup: /system.slice/cloud_sql_proxy.service
             └─7872 /usr/local/bin/cloud_sql_proxy -instances=[your_gcp_project_id]:asia-northeast1:iap-gce-cloudsql-linux-2021=tcp:0.0.0.0:3306 -credential_file=/usr/local/bin/iap-gce-cloudsql-linux_sa_key
```

+ Cloud SQL に接続確認

```
mysql -h 0.0.0.0 -u root -p
```
```
### 例

# mysql -h 0.0.0.0 -u root -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 1475
Server version: 8.0.18-google (Google)

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> exit
Bye
```

+ VM からログアウト

```
exit
```

## IAP for TCP forwarding

+ Firewall Rule を追加

```
### IAP からの 3306 を許可する
gcloud beta compute firewall-rules create ${_common}-allow-db \
  --network ${_common}-network \
  --source-ranges=35.235.240.0/20 \
  --allow tcp:3306 \
  --target-tags ${_common}-allow-db \
  --project ${_gcp_pj_id}
```

+ VM の Network tags を追加

```
gcloud beta compute instances add-tags ${_common}-vm \
  --tags=${_common}-allow-db \
  --zone=${_zone} \
  --project ${_gcp_pj_id}
```

+ VM の Network tags を確認

```
WIP
```

+ IAP for TCP forwarding を貼る
  + 今回は 3306 のみ貼る
  + https://cloud.google.com/iap/docs/using-tcp-forwarding#tunneling_other_tcp_connections

```
gcloud beta compute start-iap-tunnel ${_common}-vm 3306 \
  --local-host-port=0.0.0.0:13306 \
  --zone=${_zone} \
  --project ${_gcp_pj_id}
```
```
### 例

# gcloud beta compute start-iap-tunnel ${_common}-vm 3306 \
>   --local-host-port=0.0.0.0:13306 \
>   --zone=${_zone} \
>   --project ${_gcp_pj_id}
Testing if tunnel connection works.
Listening on port [13306].

---> このコンソールはこのまま
```

+ 新しくコンソールを起動し `mysql` コマンドを実行する

```
mysql -h 0.0.0.0 -P 13306 -u root -p
```

```
# mysql -h 0.0.0.0 -P 13306 -u root -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 1606
Server version: 8.0.18-google (Google)

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> exit
Bye
```

---> これでやりたいことが出来た
