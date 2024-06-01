# gcloud builds



```
export _gc_pj_id='Your Googcle Cloud Project ID'
export _region='asia-northeast1'
```

## Service Account

[Service Accounts](../../iam-admin/serviceaccounts/)

```
gcloud beta iam service-accounts create SERVICE_ACCOUNT_ID \
  --description="DESCRIPTION" \
  --display-name="DISPLAY_NAME" \
  --project ${_gc_pj_id}
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
  --project ${_gc_pj_id}
```

## Trigger を Enable / Disable したい場合

現状は Trigger の設定を Export して、編集し、再度 import する必要がある

https://cloud.google.com/build/docs/automating-builds/create-manage-triggers#disabling_a_build_trigger

## 2nd

### 接続を作成

TBD

### Repository を作成

+ GitHub の Repository の所有者を `{{ User-Name }}` , Repository の名前を `{{ Repo-Name }}`

```
gcloud beta builds repositories create hogehoge-fugafuga \
  --connection github \
  --region ${_region} \
  --remote-uri='https://github.com/{{ User-Name }}/{{ Repo-Neme }}.git' \
  --project ${_gc_pj_id}
```

### Push to branch

+ Trigger

```
gcloud beta builds triggers create github \
  --name='hogehoge-trigger' \
  --repository="projects/${_gc_pj_id}/locations/${_region}/connections/github/repositories/hogehoge-fugafuga" \
  --branch-pattern="^main$" \
  --build-config="cloudbuild.yaml" \
  --region ${_region} \
  --service-account="projects/${_gc_pj_id}/serviceAccounts/xxx-xxx-xxx@${_gc_pj_id}.iam.gserviceaccount.com" \
  --project ${_gc_pj_id}
```

### Manual Trigger

- 注意
  - region を明示する必要がある

```
gcloud beta builds triggers create manual \
  --name='hogehoge-trigger-manual' \
  --region ${_region} \
  --build-config="cloudbuild.yaml" \
  --repository="projects/${_gc_pj_id}/locations/${_region}/connections/github/repositories/hogehoge-fugafuga" \
  --branch='my-branch' \
  --project ${_gc_pj_id}
```

