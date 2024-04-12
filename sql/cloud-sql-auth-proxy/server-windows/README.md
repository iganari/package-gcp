# Login to Cloud SQL using the Cloud SQL Auth proxy from Windows Server

## 概要

一般的な Windows Server 内から Cloud SQL Auth proxy で Cloud SQL に繋ぐ方法です

Cloud SQL Auth proxy をサービス化することで、他のアプリケーションからも定常的に利用出来る用にしておくとよいでしょう

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-01-01.png)

## 0. やってみる

## 1. Google Cloud での作業

### 1-1. API の有効化

```
### Service Account が実際に属している Google Cloud Project にて必要
sqladmin.googleapis.com
```

### 1-2. Cloud SQL の準備

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

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-01-02-01.png)

### 1-3. Service Account の作成と Role の付与

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


## 3. VM での作業

インターネットに出ることが出来る VM を用意してください

サンプルとして GCE Instance on Google Cloud の作成コマンドを記載しておきます

### 3-1. GCE Instance の作成

<details>
<summary>GCE Instance の作成サンプル</summary>

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



![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-01-01.png)

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-01-02.png)

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-01-03.png)

</details>

### 3-2. Cloud SDK のインストール

公式ドキュメントを参考に Windows 用の Cloud SDK のインストール

[gcloud CLI をインストールする (Windows)](https://cloud.google.com/sdk/docs/install?hl=en#windows)

### 3-3. MySQL コマンドのインストール

<details>
<summary>Microsoft Visual C++ が必要になるので先にインストールしておく</summary>

+ https://learn.microsoft.com/ja-JP/cpp/windows/latest-supported-vc-redist?view=msvc-170 からダウンロードする

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-03-01.png)

</details>

<details>
<summary>MySQL をインストールする</summary>

+ Windows 用のインストーラーがダウンロード出来るので、それを用いて MySQL をインストールする
  + https://dev.mysql.com/downloads/installer/ からダウンロードする

+ インストーラーによる MySQL コマンドのインストール

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-03-02.png)

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-03-03.png)

</details>


<details>
<summary>Path の確認 (自動で設定されていることを確認)</summary>

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-03-04.png)

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-03-05.png)

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-03-06.png)

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-03-07.png)

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-03-08.png)

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-03-09.png)

</details>

<details>
<summary>mysql コマンドが実行出来ることを確認 (実際は mysqlsh となる)</summary>

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-03-10.png)

</details>


<details>
<summary>MySQL Workbench が正常に起動するか確認する</summary>

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-03-11.png)

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-03-12.png)

</details>


### 3-4. Cloud SQL Auth Proxy を実行する

Cloud SQL のバイナリファイルを公式サイトからダウンロードする

https://cloud.google.com/sql/docs/mysql/connect-auth-proxy?hl=en#windows-64-bit

上記でダウンロードしたバイアリファイルを特定のフォルダに移動する

今回は以下とする

```
C:\Program Files\Google\SQL
```

<details>
<summary>Cloud SQL Auth Proxy を上記の Path に置く</summary>

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-04-01.png)

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-04-02.png)

</details>

<details>
<summary>Google Cloud で作成した Service Account の Key を VM 上に移動し、同じ Path に設置する</summary>

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-04-03.png)

</details>

<details>
<summary>Cloud SQL Auth Proxy を実行する</summary>

```
cloud-sql-proxy.x64.exe --address 127.0.0.1 --port 13306 --credentials-file="C:\Program Files\Google\SQL\sa-key-cloud-sql-auth-proxy-client.json" {{ Your Google Cloud Project ID }}:asia-northeast1:public-sql
```

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-04-04.png)

</details>

---> これを実施しているうちに MySQL Workbencth で疎通テストを行う

### 3-5. MySQL Workbench で Cloud SQL Auth Proxy 経由で Cloud SQL に接続する

<details>
<summary>MySQL Workbench を起動する</summary>

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-05-01.png)

</details>

<details>
<summary>Cloud SQL for MySQL の接続情報を入れる</summary>

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-05-02.png)

</details>

<details>
<summary>MySQL のパスワードを入れる</summary>

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-05-03.png)

</details>

<details>
<summary>接続テストが正常に完了することを確認</summary>


![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-05-04.png)

</details>

<details>
<summary>Cloud SQL for MySQL にログイン出来ました :)</summary>

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/sql/cloud-sql-auth-proxy/2024-windows-03-05-05.png)

</details>

---> 接続することが出来ました :)

### 3-5. [WIP] 常時実行の設定をする

Windows の場合は、「サービス化」をすることで常時起動をすることができるはず

Powershell を Administoreer で起動する


+ https://learn.microsoft.com/ja-jp/dotnet/core/extensions/windows-service#create-the-windows-service
+ https://hack-life.hatenablog.com/entry/register-as-a-windows-service-with-arguments
