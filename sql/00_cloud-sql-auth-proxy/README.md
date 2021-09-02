# Cloud SQL Auth proxy

## 概要

外部から Cloud SQL にセキュアにログインするための proxy

+ 公式ドキュメント

```
About the Cloud SQL Auth proxy
https://cloud.google.com/sql/docs/mysql/sql-proxy?hl=en
```
```
Connecting using the Cloud SQL Auth proxy
https://cloud.google.com/sql/docs/mysql/connect-admin-proxy?hl=en
```

## やってみる

### Cloud SQL の準備

以下の条件で Cloud SQL が出来ていることを前提とします

+ Cloud SQL for MySQL を使用
+ 外部 IP アドレス無し / 内部 IP アドレスのみの Cloud SQL

### Service Account の作成と role の付与

+ 環境変数

```
export _gcp_pj_id='Your GCP Project ID'
```

+ Service Account の作成

```
gcloud beta iam service-accounts create cloud-sql-auth-proxy-test \
  --display-name="for Cloud SQL Auth proxy" \
  --project ${_gcp_pj_id}
```

+ role の付与

```
gcloud beta projects add-iam-policy-binding ${_gcp_pj_id} \
  --member="serviceAccount:cloud-sql-auth-proxy-test@${_gcp_pj_id}.iam.gserviceaccount.com" \
  --role="roles/cloudsql.admin" \
  --project ${_gcp_pj_id}
```

+ Key の作成

```
gcloud beta iam service-accounts keys create sa-key-cloud-sql-auth-proxy \
  --iam-account=cloud-sql-auth-proxy-test@${_gcp_pj_id}.iam.gserviceaccount.com \
  --project ${_gcp_pj_id}
```
```
$ ls | grep sa-key-cloud-sql-auth-proxy
sa-key-cloud-sql-auth-proxy
```


### VM での準備

+ 以下の OS の VM があることを前提とします
  + 他の OS でも実行出来ますので詳しくは公式ドキュメントを参照してください

```
$ cat /etc/os-release
NAME="Ubuntu"
VERSION="21.04 (Hirsute Hippo)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 21.04"
VERSION_ID="21.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=hirsute
UBUNTU_CODENAME=hirsute
```
```
$ uname -p
x86_64
```

+ Cloud SQL Auth proxy を取得し、実行可能な状態にします

```
sudo wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /usr/local/bin/cloud_sql_proxy
sudo chmod +x /usr/local/bin/cloud_sql_proxy
```

+ 実行可能か確認します

```
cloud_sql_proxy --version
```
```
### 例

$ cloud_sql_proxy --version
Cloud SQL Auth proxy: 1.24.0+linux.amd64
```

+ Service Account を `/usr/local/bin/` に置いておきます

```
$ ls -1 /usr/local/bin/
cloud_sql_proxy
sa-key-cloud-sql-auth-proxy
```









