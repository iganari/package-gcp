# Basic

WIP


## Artifact Registry を使った例

### Artifact Registry を準備する

+ GCP Project ID とリージョンを環境変数に用意する

```
export _gc_pj_id='Your GCP Project ID'
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

## Cloud Run を使った例

+ [nginx のサンプル](../../run/_basic/nginx/)
+ [Python のサンプル](../../run/_basic/python/)
