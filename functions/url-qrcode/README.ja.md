# Cloud Fanctions の上で QRCode のサンプルを作成する

## 準備

+ 作業用の Docker コンテナを起動する ---> :whale:

```
sh docker-build-run.sh
```

## :whale: gcloud のコンフィグの作成

```
export _setting_name='create-qr'

gcloud config configurations create ${_setting_name}
```

## :whale: 認証


[IAM & admin](../../iam-admin/README.ja.md)


## :whale: プロジェクトの設定

+ 必須

```
export _pj='iganari_test-qr'
gcloud config set project ${_pj}
```

+ しなくてもよい

```
gcloud config set compute/region asia-northeast1
gcloud config set compute/zone asia-northeast1-a
```

+ 確認

```
gcloud config configurations list
```

## :whale: GCP にデプロイ

+ デプロイする
    + `us-central1` に Functions がデプロイされます

```
gcloud functions deploy url_qrcode \
    --runtime python37 \
    --trigger-http
```

+ リージョンを指定してデプロイする
    + `asia-northeast1`

```
gcloud functions deploy url_qrcode \
    --region asia-northeast1 \
    --runtime python37 \
    --trigger-http
```

## ブラウザで確認

### デフォルトの場合


+ `デプロイしたリージョン` , `GCP のプロジェクト名` で、 URL が変わります

```
https://{デプロイしたリージョン}-{GCP のプロジェクト名}.cloudfunctions.net/url_qrcode
```

+ 以下は `デプロイしたリージョン` = `asia-northeast1` , `GCP のプロジェクト名` = `iganari_test-qr` の場合の架空の URL です

```
### 架空の URL
https://asia-northeast1-iganari_test-qr.cloudfunctions.net/url_qrcode
```

### クエリパラメータを使用する

+ `q` という変数に、存在する URL をいれて実行すると、その URL を含んだ URL が記録出来ます
    + 例として `https://www.bing.com/` を指定します
    + `q` は [ここ](WIP) で設定している値

```
https://{デプロイしたリージョン}-{GCP のプロジェクト名}/url_qrcode?q=https://www.bing.com/
```

## :whale: リソースの削除

+ デフォルトにデプロイした際の削除
    + `us-central1` に Functions がデプロイされている

```
gcloud functions delete url_qrcode
```

+ リージョンを指定してデプロイした際の削除
    + `asia-northeast1` を指定している

```
gcloud functions delete url_qrcode --region asia-northeast1
```
