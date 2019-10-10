# Cloud Fanctions の上で QRCode のサンプルを作成する

## コンフィグの作成

```
export _setting_name='create-qr'

gcloud config configurations create ${_setting_name}
```

## 認証

WIP (Link)

## プロジェクトの設定

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

## GCP にデプロイ

+ デプロイする
    + `us-central1` に Functions がデプロイされます

```
gcloud functions deploy url-qrcode \
    --runtime python37 \
    --trigger-http
```

+ リージョンを指定してデプロイする
    + `asia-northeast1`

```
gcloud functions deploy url-qrcode \
    --region asia-northeast1 \
    --runtime python37 \
    --trigger-http
```

## ブラウザで確認

WIP


## リソースの削除

+ デフォルトにデプロイした際の削除
    + `us-central1` に Functions がデプロイされている

```
WIP
```

+ リージョンを指定してデプロイした際の削除
    + `asia-northeast1` を指定している

```
gcloud functions delete url-qrcode --region asia-northeast1
```
