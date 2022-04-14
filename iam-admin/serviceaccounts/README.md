# Service Accounts

TBD

```
gcloud beta iam service-accounts create SERVICE_ACCOUNT_ID \
    --description="DESCRIPTION" \
    --display-name="DISPLAY_NAME"
```

```
gcloud beta projects add-iam-policy-binding PROJECT_ID \
    --member="serviceAccount:SERVICE_ACCOUNT_ID@PROJECT_ID.iam.gserviceaccount.com" \
    --role="ROLE_NAME"
```
