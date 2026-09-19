# Cloud Run に Apache をデプロイする

## サンプル

```
export _gc_pj_id='Your Google Cloud Project ID'
export _default_region='asia-northeast1'

export _common='pkg-gcp'
```

- 認証をつけない Service

```
gcloud beta run deploy ${_common}-httpd \
  --description='[package-gcp] Apache のサンプル' \
  --image httpd:latest \
  --port 80 \
  --platform managed \
  --region ${_default_region} \
  --allow-unauthenticated \
  --project ${_gc_pj_id}
```
