# Artifact Registry

## どんなもの?

下記を読み込んでおくと良い

公式ドキュメント

+ Artifact Registry
  + https://cloud.google.com/artifact-registry?hl=en
+ Overview of Artifact Registry
  + https://cloud.google.com/artifact-registry/docs/overview
+ Container Registry からの移行
  + https://cloud.google.com/artifact-registry/docs/transition/transition-from-gcr?hl=ja
+ Transitioning from Container Registry
  + https://cloud.google.com/artifact-registry/docs/transition/transition-from-gcr

Tips

1. 公式ドキュメントだと `Google` や `Cloud` は付かず、 `Artifact Registry` と表記されている

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

+ Artifact Registry Docker リポジトリに対する認証を構成する
  + asia-northeast1 のみ設定する
  + https://cloud.google.com/artifact-registry/docs/docker/authentication#gcloud-helper

```
gcloud auth configure-docker asia-northeast1-docker.pkg.dev
```
```
### 上記をしない場合は以下のようなエラーが出る(非常に分かりづらい)

denied: Permission "artifactregistry.repositories.downloadArtifacts" denied on resource "${_region}-docker.pkg.dev/${_gcp_pj_id}/${_ar_repo}" (or it may not exist)
```



## [脆弱性スキャン機能](./vulnerability-scanning)

マネージドの脆弱性スキャン機能がある
