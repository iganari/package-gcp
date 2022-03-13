# subscription

## Unacked message を削除したい時

```
export _gcp_pj_id='Your GCP Project ID'

export _my_subscriptions_name='Your Subscription Name'
```

+ 一括確認

```
gcloud beta pubsub subscriptions pull test-pull \
  --max-messages 100 \
  --project ${_gcp_pj_id}
```

+ 一括削除 ( ACK ) 

```
gcloud beta pubsub subscriptions pull test-pull \ 
  --auto-ack \
  --max-messages 100 \
  --project ${_gcp_pj_id}
```
