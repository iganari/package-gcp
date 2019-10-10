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

```
WIP
```

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


+ `デプロイしたリージョン` , `GCP のプロジェクト名` で、 URL が変わります
    + 以下は , `デプロイしたリージョン` = `asia-northeast1` , `GCP のプロジェクト名` = `iganari_test-qr` の場合の架空の URL() です

```
### 架空の URL
https://asia-northeast1-iganari_test-qr.cloudfunctions.net/url_qrcode
```



## :whale: リソースの削除

+ デフォルトにデプロイした際の削除
    + `us-central1` に Functions がデプロイされている

```
WIP
```

+ リージョンを指定してデプロイした際の削除
    + `asia-northeast1` を指定している

```
gcloud functions delete url_qrcode --region asia-northeast1
```
