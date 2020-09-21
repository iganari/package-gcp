# Workflows

:warning: 仮置の PATG

+ 公式ドキュメント
  + https://cloud.google.com/workflows/docs/quickstart-gcloud

## gcloud コマンドでやっていく

+ GCP 認証

```
gcloud auth login -q
```

+ GCP Project の設定

```
_gcp_id='Your GCP Project ID'

gcloud beta config set project ${_gcp_id}
```

+ API の有効化

```
gcloud beta services enable workflows.googleapis.com
```
```
### EX.

# gcloud beta services enable workflows.googleapis.com
Operation "operations/acf.31078caf-7ae0-4777-a56c-1876f872ee2a" finished successfully.
```

+ Service Account の作成

```
gcloud beta iam service-accounts create workflows-test
```

+ 作成した Service Account に Workflows の実行権限を付与する

```
_sa_email=$(gcloud beta iam service-accounts list | grep workflows-test | awk '{print $1}')

gcloud projects add-iam-policy-binding ${_gcp_id} --member "serviceAccount:${_sa_email}" --role "roles/workflows.editor"
```
```
### Ex.

# gcloud projects add-iam-policy-binding ${_gcp_id} --member "serviceAccount:${_sa_email}" --role "roles/workflows.editor"

Updated IAM policy for project ['Your GCP Project ID].
bindings:
- members:
  - user:hogehoge@example.com
  role: roles/owner
- members:
  - serviceAccount:workflows-test@your_gcp_project_id.iam.gserviceaccount.com
  role: roles/workflows.editor
etag: BwWv0vVvnlQ=
version: 1
```

+ YAML の作成


```
cat << __EOF__ > myFirstWorkflow.yaml
- getCurrentTime:
    call: http.get
    args:
        url: https://us-central1-workflowsample.cloudfunctions.net/datetime
    result: currentTime
- readWikipedia:
    call: http.get
    args:
        url: https://en.wikipedia.org/w/api.php
        query:
            action: opensearch
            search: \${currentTime.body.dayOfTheWeek}
    result: wikiResult
- returnResult:
    return: \${wikiResult.body[1]}
__EOF__
```


+ Deploy the workflow by entering the following command:

```
gcloud beta workflows deploy myFirstWorkflow \
    --source=myFirstWorkflow.yaml \
    --service-account=${_sa_email}
```
```
### EX.

# gcloud beta workflows deploy myFirstWorkflow \
>     --source=myFirstWorkflow.yaml \
>     --service-account=${_sa_email}
Waiting for operation [operation-1600703322026-5afd4c8e6710e-63475175-37528fc3] to complete...done.
createTime: '2020-09-21T15:48:43.251748211Z'
name: projects/your_gcp_project_id/locations/us-central1/workflows/myFirstWorkflow
revisionCreateTime: '2020-09-21T15:48:43.385108113Z'
revisionId: 000001-f51
serviceAccount: projects/your_gcp_project_id/serviceAccounts/workflows-test@your_gcp_project_id.iam.gserviceaccount.com
sourceContents: |
  - getCurrentTime:
      call: http.get
      args:
          url: https://us-central1-workflowsample.cloudfunctions.net/datetime
      result: currentTime
  - readWikipedia:
      call: http.get
      args:
          url: https://en.wikipedia.org/w/api.php
          query:
              action: opensearch
              search: ${currentTime.body.dayOfTheWeek}
      result: wikiResult
  - returnResult:
      return: ${wikiResult.body[1]}
state: ACTIVE
updateTime: '2020-09-21T15:48:43.464673277Z'
```


+ Execute the workflow by entering the following command:

```
gcloud beta workflows execute myFirstWorkflow
```
