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
```
### Ex.

# gcloud beta workflows execute myFirstWorkflow
Created [9d621782-f4c3-4391-a740-241d4c58e801].

To view the workflow status, you can use following command:
gcloud beta workflows executions describe 9d621782-f4c3-4391-a740-241d4c58e801 --workflow myFirstWorkflow
```

```
gcloud beta workflows executions describe 9d621782-f4c3-4391-a740-241d4c58e801 --workflow myFirstWorkflow
```
```
### EX.

# gcloud beta workflows executions describe 9d621782-f4c3-4391-a740-241d4c58e801 --workflow myFirstWorkflow
argument: 'null'
endTime: '2020-09-21T16:05:00.054117727Z'
name: projects/project_number/locations/us-central1/workflows/myFirstWorkflow/executions/9d621782-f4c3-4391-a740-241d4c58e801
result: '["Monday","Monday Night Football","Monday Night Wars","Monday Night Countdown","Monday
  Night Golf","Monday Mornings","Monday.com","Monday (The X-Files)","Monday Night
  Baseball","Monday Monday"]'
startTime: '2020-09-21T16:04:59.694315927Z'
state: SUCCEEDED
workflowRevisionId: 000001-f51
```


## ここからは発展

VM Instance を 起動する Functions を作って、それを Workflows でやる -> かつ通知が出来てればいいな

+ Compute Engine インスタンスを設定する
  + 参考: https://cloud.google.com/scheduler/docs/start-and-stop-compute-engine-instances-on-a-schedule?hl=ja#gcloud


+ API の有効化

```
gcloud beta services enable compute.googleapis.com -q && \
gcloud beta services enable cloudfunctions.googleapis.com -q && \
gcloud beta services enable cloudbuild.googleapis.com -q && \
gcloud beta services enable run.googleapis.com -q
                            run.googleapis.com

```



+ VM Instance 作成

```
gcloud beta compute instances create dev-instance \
    --network default \
    --zone asia-northeast1-b \
    --labels=env=dev
```


+ VM Instance の確認

```
gcloud beta compute instances list
```
```
### EX.

# gcloud beta compute instances list
NAME          ZONE               MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP  STATUS
dev-instance  asia-northeast1-b  n1-standard-1               10.146.0.2   34.85.14.63  RUNNING
```


+ 公式サンプルの clone

```
git clone https://github.com/GoogleCloudPlatform/nodejs-docs-samples.git
cd nodejs-docs-samples/functions/scheduleinstance/
```

+ 起動の関数と停止の関数を作成する

```
gcloud beta functions deploy startInstancePubSub \
    --trigger-topic start-instance-event \
    --runtime nodejs10 \
    --allow-unauthenticated
```
```
gcloud beta functions deploy stopInstancePubSub \
    --trigger-topic stop-instance-event \
    --runtime nodejs10 \
    --allow-unauthenticated
```

## Cloud Run

+ ドキュメント
  + https://github.com/knative/docs/blob/master/docs/serving/samples/hello-world/helloworld-go/helloworld.go


```
git clone https://github.com/knative/docs.git
cd cd docs/docs/serving/samples/hello-world/helloworld-go/
```

```
gcloud builds submit --tag gcr.io/${_gcp_id}/helloworld
```
```
gcloud beta run deploy helloworld-workflow --image gcr.io/${_gcp_id}/helloworld --platform managed --region asia-northeast1 --allow-unauthenticated
```

```
Deploying container to Cloud Run service [helloworld-workflow] in project [Your GCP Project ID] region [asia-northeast1]
✓ Deploying new service... Done.
  ✓ Creating Revision...
  ✓ Routing traffic...
Done.
Service [helloworld-workflow] revision [helloworld-workflow-00001-bup] has been deployed and is serving 100 percent of traffic at https://helloworld-workflow-bkkqslakpa-an.a.run.app
```
```
# https://cloud.google.com/workflows/docs/sample-workflows#get-request-function

- callMyFunction:
    call: http.get
    args:
        url: https://helloworld-workflow-bkkqslakpa-an.a.run.app
        auth:
            type: OIDC
        query:
            someVal: "Hello World"
            anotherVal: 123
    result: theMessage
- returnValue:
    return: ${theMessage.body}
```



```
localhost:8080/?key=hello%20golangcode.com
```
