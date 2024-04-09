# Login to Cloud SQL using the Cloud SQL Auth proxy from Windows Server

## 概要

一般的な Server 内から Cloud SQL Auth proxy で Cloud SQL に繋ぐ方法です

Cloud SQL Auth proxy をサービス化することで、他のアプリケーションからも定常的に利用出来る用にしておくとよいでしょう

![](https://raw.githubusercontent.com/iganari/artifacts/feature/add-sql-authproxy/googlecloud/sql/instances/2024-cloud-sql-auth-proxy-01.png)

## やってみる

### Cloud SQL の準備

+ 以下の条件で Cloud SQL が出来ていることを前提とします
  + Cloud SQL for MySQL
    + Version は最新のもの
  + 外部 IP アドレス有り
    + 内部 IP アドレス無し

+ Cloud SQL の Connection name を控えておきます
  + 以下のような名前になります

```
{Your Google Cloud Project ID}:{Cloud SQL Instance Region}:{Cloud SQL Instance Name}
```

![](https://raw.githubusercontent.com/iganari/artifacts/feature/add-sql-authproxy/googlecloud/sql/instances/2024-cloud-sql-auth-proxy-02.png)

### Service Account の作成と Role の付与

+ 環境変数

```
export _gc_pj_id='Your Google Cloud Project ID'
export _common='cloud-sql-auth-proxy'
```

+ Service Account の作成

```
gcloud beta iam service-accounts create sa-${_common}-client \
  --display-name sa-${_common}-client \
  --description="for Cloud SQL Auth Proxy" \
  --project ${_gc_pj_id}
```

+ Role の付与
  + Role: `Cloud SQL Client (roles/cloudsql.client)` を付与する

```
gcloud beta projects add-iam-policy-binding ${_gc_pj_id} \
  --member="serviceAccount:sa-${_common}-client@${_gc_pj_id}.iam.gserviceaccount.com" \
  --role="roles/cloudsql.client" \
  --project ${_gc_pj_id}
```

+ Key の作成

```
gcloud beta iam service-accounts keys create sa-key-${_common}-client.json \
  --iam-account=sa-${_common}-client@${_gc_pj_id}.iam.gserviceaccount.com \
  --project ${_gc_pj_id}
```
```
### 確認

$ ls | grep sa-key-${_common}-client.json
sa-key-cloud-sql-auth-proxy-client.json
```

---> この Key は後述の VM 内で使用します


### VM の準備

インターネットに出ることが出来る VM を用意してください

サンプルとして GCE Instance の作成コマンド

+ VPC Network の作成

```
gcloud beta compute networks create ${_common}-network \
  --subnet-mode=custom \
  --project ${_gc_pj_id}
```

+ サブネットの作成

```
export _region='asia-northeast1'
# export _zone=`echo ${_region}-b`
export _sub_network_range='10.0.0.0/16'


gcloud beta compute networks subnets create ${_common}-subnets \
  --network ${_common}-network \
  --region ${_region} \
  --range ${_sub_network_range} \
  --project ${_gc_pj_id}
```

+ GCE Instance 専用の Service Account の作成

```
gcloud beta iam service-accounts create sa-${_common}-vm \
  --display-name sa-${_common}-vm \
  --description="for GCE Instance ${_common}-vm" \
  --project ${_gc_pj_id}
```

+ Firewall Rule

```
export _my_ip='Your IP Address'   ## https://www.cman.jp/network/support/go_access.cgi


### RDP 用
gcloud beta compute firewall-rules create ${_common}-network-allow-ingress-rdp \
  --network ${_common}-network \
  --action ALLOW \
  --rules tcp:3389,icmp \
  --source-ranges ${_my_ip} \
  --target-service-accounts sa-${_common}-vm@${_gc_pj_id}.iam.gserviceaccount.com \
  --project ${_gc_pj_id}
```

+ 外部 IP アドレス

```
gcloud beta compute addresses create ${_common}-vm-ip \
  --description='for ${_common}-vm' \
  --network-tier premium \
  --region ${_region} \
  --project ${_gc_pj_id}
```

+ GCE Instance の作成

```
export _os_image='windows-server-2022-dc-v20240328'
export _os_family='windows-cloud'






gcloud beta compute instances create ${_common}-vm \
  --zone ${_region}-b \
  --machine-type e2-medium \
  --network-interface=address=${_common}-vm-ip,subnet=${_common}-subnets \
  --service-account=sa-${_common}-vm@${_gc_pj_id}.iam.gserviceaccount.com \
  --scopes=https://www.googleapis.com/auth/cloud-platform \
  --create-disk=auto-delete=yes,boot=yes,image=projects/${_os_family}/global/images/${_os_image},mode=rw,size=50 \
  --shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring \
  --project ${_gc_pj_id}
```

Cloud Console から Windows User と Password の生成

```
iganari
$jbrCQ!3Vg9}#Oj
34.146.136.227
```

スクショ





### VM Cloud SQL

公式ドキュメントを参考に Windows 用の Cloud SDK のインストール

[gcloud CLI をインストールする (Windows)](https://cloud.google.com/sdk/docs/install?hl=en#windows)

### MySQL コマンド

https://dev.mysql.com/downloads/installer/

Windows 用のインストーラーがダウンロード出来るので、それを用いて MySQL をインストールする

今回は Client Only で良い

スクショ

Microsoft Visual C++ が必要

https://learn.microsoft.com/ja-JP/cpp/windows/latest-supported-vc-redist?view=msvc-170

からダウンロードする

スクショ


https://www2.mouse-jp.co.jp/ssl/user_support2/sc_faq_documents.asp?FaqID=35886


### Cloud SQL Auth Proxy

https://cloud.google.com/sql/docs/mysql/connect-auth-proxy?hl=en#windows-64-bit


```
./cloud-sql-proxy --address 0.0.0.0 --port 103306 --credentials-file=C:\Users\iganari\Desktop\cloud-sql-proxy.exe INSTANCE_CONNECTION_NAME
```