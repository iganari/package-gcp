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

