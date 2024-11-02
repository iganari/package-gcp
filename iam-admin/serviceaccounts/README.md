# Service Accounts

## 基本形

+ Service Account の作成

```
gcloud beta iam service-accounts create SERVICE_ACCOUNT_ID \
  --display-name="DISPLAY_NAME" \
  --description="DESCRIPTION" \
  --project PROJECT_ID
```

+ 作成した Service Account に Role を付与する

```
gcloud beta projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:SERVICE_ACCOUNT_ID@PROJECT_ID.iam.gserviceaccount.com" \
  --role="ROLE_NAME" \
  --condition None
```

## Secret Manager につける

+ Service Account の作成

```
gcloud beta iam service-accounts create SERVICE_ACCOUNT_ID \
  --description="DESCRIPTION" \
  --display-name="DISPLAY_NAME" \
  --project PROJECT_ID
```

+ 作成した Service Account が Secret Manager にアクセス出来るように Role を付与する

```
gcloud beta projects add-iam-policy-binding {Secret ID} \
  --member="serviceAccount:SERVICE_ACCOUNT_ID@PROJECT_ID.iam.gserviceaccount.com" \
  --role="ROLE_NAME" \
  --project PROJECT_ID
```

