# Secret Manager

## 概要

Cloud Secret Manager ( 以下、 CMS ) は機密データを GCP 内に保存することが出来、適宜取り出して使用することが出来る

アクセス権などは IAM で管理される

CMS で管理しているデータは secret という

https://cloud.google.com/secret-manager/docs/overview

## CMS の API の有効化

+ 環境変数に GCP Project をいれておく

```
export _gcp_pj_id='Your GCP Project ID'
```

+ GCP Project 内における API の有効化
  + `secretmanager.googleapis.com`

```
gcloud beta services enable secretmanager.googleapis.com --project ${_gcp_pj_id}
```

## 新規で secret を作成する

+ 平文の場合
  + echo をリダイレクトさせる

```
echo -n "this is my super secret data" | gcloud beta secrets create secret-hirabun --data-file=- --project ${_gcp_pj_id}
```

+ ファイルの場合

```
echo -n 'this is my super secret data in file' > /tmp/secret
gcloud beta secrets create secret-file --data-file=/tmp/secret --project ${_gcp_pj_id}
```

## secret のリストの確認

```
gcloud beta secrets list --project ${_gcp_pj_id}
```
```
### Ex.

# gcloud beta secrets list --project ${_gcp_pj_id}
NAME            CREATED              REPLICATION_POLICY  LOCATIONS
secret-file     2021-11-04T05:36:08  automatic           -
secret-hirabun  2021-11-04T05:32:08  automatic           -
```

## secret のバージョンを確認する

+ `secret-hirabun` のバージョンを確認する

```
gcloud beta secrets versions list secret-hirabun --project ${_gcp_pj_id}
```
```
### 例

# gcloud beta secrets versions list secret-hirabun --project ${_gcp_pj_id}
NAME  STATE    CREATED              DESTROYED
1     enabled  2021-11-04T05:32:10  -
```

## secret の復号化

+ `secret-hirabun` のバージョン 1 を復号化してみる
  + 上記で確認したバージョンも必要になる

```
gcloud beta secrets versions access 1 --secret secret-hirabun --project ${_gcp_pj_id}
```
```
### 例

# gcloud beta secrets versions access 1 --secret secret-hirabun --project ${_gcp_pj_id}
this is my super secret data
```

+ `secret-file` のバージョン 1 を復号化してみる
  + 上記で確認したバージョンも必要になる

```
gcloud beta secrets versions access 1 --secret secret-file --project ${_gcp_pj_id}
```
```
### 例

# gcloud beta secrets versions access 1 --secret secret-file --project ${_gcp_pj_id}
this is my super secret data in file
```

## secret の削除

+ `secret-hirabun` を削除

```
gcloud beta secrets delete secret-hirabun --project ${_gcp_pj_id}
```

+ `secret-file` を削除

```
gcloud beta secrets delete secret-file --project ${_gcp_pj_id}
```

## 他に出来ること

+ secret の中でバージョン管理が出来る
  + `gcloud beta secrets versions`
  + secret name は変更せず、値のみ変えたい場合
+ secret の有効期限を設定できる
  + `gcloud beta secrets create --expire-time`

それ以外も `gcloud beta secrets --help` で確認することが出来る
