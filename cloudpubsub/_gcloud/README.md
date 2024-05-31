# gcloud pubsub

## 準備

```
export _gc_pj_id='Your Google Cloud Project ID'
```

- Service Account

```
export _gc_pj_number=`gcloud beta projects describe ${_gc_pj_id} --format="value(projectNumber)"`
export _sa_pubsub=`echo service-${_gc_pj_number}@gcp-sa-pubsub.iam.gserviceaccount.com`

echo ${_sa_pubsub}
```

## Topic 作成


```
gcloud beta pubsub topics create mytopic --project ${_gc_pj_id}
```

## subscriptions

```
gcloud beta pubsub subscriptions create mysub \
  --topic ${_common} \
  --project ${_gc_pj_id}
```
