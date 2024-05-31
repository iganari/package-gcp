# gcloud pubsub

## Topic 作成

```
export _gc_pj_id='Your Google Cloud Project ID'
```
```
gcloud beta pubsub topics create mytopic --project ${_gc_pj_id}
```

## subscriptions

```
gcloud beta pubsub subscriptions create mysub \
  --topic mytopic \
  --topic-project ${_gc_pj_id} \
  --project ${_gc_pj_id}
```
