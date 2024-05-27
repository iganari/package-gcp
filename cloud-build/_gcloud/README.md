# gcloud builds



```
export _gc_pj_id='Your Googcle Cloud Project ID'
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
  --region asia-northeast1 \
  --remote-uri='https://github.com/{{ User-Name }}/{{ Repo-Neme }}.git' \
  --project ${_gc_pj_id}
```
