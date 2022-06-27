# gcloud builds


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
