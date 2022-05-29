# Functions 経由


```
export _gcp_pj_id='Your GCP Project ID'
export _build_trigger_name='Your Cloud Build Trigger Name'
```




+ Cloud Build Trigger の ID の確認方法

```
gcloud beta builds triggers describe ${_build_trigger_name} \
  --project ${_gcp_pj_id} \
  --format json | jq .id -r
```
```
### 例

# gcloud beta builds triggers describe ${_build_trigger_name} \
  --project ${_gcp_pj_id} \
  --format json | jq .id -r

21cf9e5e-ccf0-4648-a747-60d6245c9693
```


## PubSub Trigger の Functions の手動デプロイ

```
export _func_name='Your Functions Name'
export _pubsub_topic='Your PubSub Topic Name'
```

```
gcloud beta functions deploy ${_func_name} \
  --region=asia-northeast1 \
  --runtime=python37 \
  --trigger-topic="${_pubsub_topic}" \
  --entry-point=run_build_trigger \
  --source=./code \
  --env-vars-file=./env.yaml \
  --project ${_gcp_pj_id}
```

```
gcloud beta functions delete ${_func_name} \
  --region=asia-northeast1 \
  --project ${_gcp_pj_id} \
  -q
```

