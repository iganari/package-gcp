# IAM & Admin

- Google Cloud との認証の仕方

## gcloud command-line tool を用いた認証方法

```
gcloud auth login
OR
gcloud auth login --no-launch-browser
```

## Service Accounts を用いた認証方法

```
WIP
```

## 基本的な使い方

### Project 単位の Role の付与方法

```
gcloud beta projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:SERVICE_ACCOUNT_ID@PROJECT_ID.iam.gserviceaccount.com" \
  --role="ROLE_NAME" \
  --condition None
```

### Cloud Storage Bucket 単位

TBD

### Service Account 単位

TBD

### BigQuery の場合












## Tipe

[Google Cloud の組織全体を見渡したい時に持っておくと良い Role 一覧](../cloud-resource-manager/organization/README.md)

