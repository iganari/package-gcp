# Cloud Run の Service 毎に Service Account を設定する

## 概要

Cloud Run の Service 毎に Service Account を設定する

## やってみる

### 0. 準備

```
export _gc_pj_id='Your Google Cloud Project ID'
export _common='pkg-gcp-run'
```
```
gcloud auth login --no-launch-browser
```

### 1. やり方

+ Service Account の作成

```
gcloud beta iam service-accounts create SERVICE_ACCOUNT_ID \
  --description="DESCRIPTION" \
  --display-name="DISPLAY_NAME" \
  --project PROJECT_ID
```

+ 作成した Service Account に Role を付与する

```
gcloud beta projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:SERVICE_ACCOUNT_ID@PROJECT_ID.iam.gserviceaccount.com" \
  --role="ROLE_NAME" \
  --project PROJECT_ID
```
