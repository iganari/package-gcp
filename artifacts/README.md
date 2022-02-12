# Artifact Registry

## どんなもの?

下記を読み込んでおくと良い

公式ドキュメント

+ Artifact Registry
  + https://cloud.google.com/artifact-registry?hl=en


Overview of Artifact Registry https://cloud.google.com/artifact-registry/docs/overview


Container Registry からの移行 https://cloud.google.com/artifact-registry/docs/transition/transition-from-gcr?hl=ja

Transitioning from Container Registry
https://cloud.google.com/artifact-registry/docs/transition/transition-from-gcr


## 使ってみる

+ gar だけ使ってみたい
  + gar ? にpush してみる
  + gar から ローカルにpull している
  + gar から GKE 上で使ってみる
  + gar を Cloud Run で使ってみる
+ アディショナル
  + gcr と gar でどう違うの?
  + gar で出来て、gcrで出来ないことって何?また、その逆は??

## Enable Service

```
export _gcp_pj_id='Your GCP Project ID'
```

+ Enable Service

```
gcloud beta services enable artifactregistry.googleapis.com --project ${_gcp_pj_id}
```

+ Check enabled

```
gcloud beta services list --enabled  --filter='artifactregistry' --project ${_gcp_pj_id}
```

+ Configure Docker

```
gcloud auth configure-docker asia-northeast1-docker.pkg.dev
```