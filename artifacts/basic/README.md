# Basic

WIP


## Artifact Registry を使った例

### Artifact Registry を準備する

+ GCP Project ID とリージョンを環境変数に用意する

```
export _gcp_pj_id='Your GCP Project ID'
export _region='asia-northeast1'
```

+ Artifact Registry のリポジトリを用意する
  + フォーマットは一番簡単な `Docker` で作成

```
export _ar_repo='Your Repository Name of Artifact Registry's'
```
```
gcloud beta artifacts repositories create ${_ar_repo} \
  --repository-format docker \
  --location ${_region} \
  --project ${_gcp_pj_id}
```

+ Artifact Registry のリポジトリの確認

```
gcloud beta artifacts repositories list --project ${_gcp_pj_id}
gcloud beta artifacts repositories describe ${_ar_repo} --location ${_region} --project ${_gcp_pj_id}
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


### コンテナイメージを Artifact Registry にアップロードする

+ コンテナイメージを作成

```
export _container_name='Your Container Name'
export _TAG='tag version'
```
```
docker tag nginx:latest ${_region}-docker.pkg.dev/${_gcp_pj_id}/${_ar_repo}/${_container_name}:${_TAG}
```

+ コンテナイメージを Artifact Registry にアップロードする

```
docker push ${_region}-docker.pkg.dev/${_gcp_pj_id}/${_ar_repo}/${_container_name}:${_TAG}
```

### Cloud Run にデプロイする

```
export _run_service='Cloud Run Service Name'
```
```
gcloud beta run deploy run-basic \
  --image ${_region}-docker.pkg.dev/${_gcp_pj_id}/${_ar_repo}/${_container_name}:${_TAG} \
  --platform managed \
  --port 80 \
  --region ${_region} \
  --allow-unauthenticated \
  --project ${_gcp_pj_id}
```








### Artifact Registry を使用する時のコンテナイメージのタグの例

```
${_region}-docker.pkg.dev/${_gcp_pj_id}/${_ar_repo}/${_container_name}:${_TAG}
```
