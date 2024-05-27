# gcloud builds

## Service Account

```
gcloud beta projects add-iam-policy-binding ${GCP Project ID} \
  --member="serviceAccount:${GCP Project Number}@cloudbuild.gserviceaccount.com" \
  --role="roles/appengine.appAdmin"
```


## Trigger の作成

### GitHub

+ Trigger 作成の基本形

```
gcloud beta builds triggers create github \
  --name='Trigger Name' \
  --repo-owner='GitHub Workspace Name' \
  --repo-name='GitHub Repository Name' \
  --branch-pattern='^main$' \
  --build-config='./cloudbuild-.yaml' \
  --substitutions=KEY1='VALUE1',KEY2='VALUE2',KEY3='VALUE3' \
  --project ${_gcp_pj_id}
```

## Trigger を Enable / Disable したい場合

現状は Trigger の設定を Export して、編集し、再度 import する必要がある

https://cloud.google.com/build/docs/automating-builds/create-manage-triggers#disabling_a_build_trigger

## 2nd

### 接続を作成

TBD

### Repository を作成

```
gcloud beta builds repositories create leadknock-dataharvest \
  --connection github \
  --region asia-northeast1 \
  --remote-uri='https://github.com/PantaRhei-Developer/leadknock-dataharvest.git' \
  --project ${_gc_pj_id}
```
