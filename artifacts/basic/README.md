# Basic

WIP


## Artifact Registry を使った例

### 0. Google Cloud に認証を通す

+ Google Cloud に認証を通す

```
gcloud auth login --no-launch-browser
```

+ docker の認証を通す

```
gcloud auth configure-docker asia-northeast1-docker.pkg.dev
```

### 1. Artifact Registry を準備する

+ 環境変数をあらかじめ用意する

```
export _gc_pj_id='Your Google Cloud Project ID'
export _region='asia-northeast1'
```
```
export _ar_repo='Your Repository Name of Artifact Registrys'
### 例
export _ar_repo='pkg-ar-basic'
```

+ Artifact Registry のリポジトリを用意する
  + フォーマットは一番簡単な `Docker` で作成

```
gcloud beta artifacts repositories create ${_ar_repo} \
  --repository-format docker \
  --location ${_region} \
  --project ${_gc_pj_id}
```

+ Artifact Registry のリポジトリの確認

```
gcloud beta artifacts repositories list --project ${_gc_pj_id}
gcloud beta artifacts repositories describe ${_ar_repo} --location ${_region} --project ${_gc_pj_id}
```

### 2. Artifact Registry にコンテナイメージを push する

+ nginx を使う

```
docker pull nginx:stable-alpine
docker tag nginx:stable-alpine ${_region}-docker.pkg.dev/${_gc_pj_id}/${_ar_repo}/nginx:latest
docker push ${_region}-docker.pkg.dev/${_gc_pj_id}/${_ar_repo}/nginx:latest
```

+ 確認する

```
WIP
```

## Cloud Run を使った例

+ [nginx のサンプル](../../run/_basic/nginx/)
+ [Python のサンプル](../../run/_basic/python/)
