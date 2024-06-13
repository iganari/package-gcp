# App Engine

## 概要

TBD

![](./_img/main.png)

## API の有効化

```
gcloud beta services enable appengine.googleapis.com --project ${_gc_pj_id}
```

## App Engine の Service の有効化

- 必要なロール
  - **App Engine Creator (roles/appengine.appCreator)**
  - **App Engine Admin (roles/appengine.appAdmin)**

- 初期設定

```
gcloud beta app create --region asia-northeast1 --project ${_gc_pj_id}
```

## memo

IAP つけたい -> https://github.com/iganari/package-gcp/issues/231
