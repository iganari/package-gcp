

```
gcloud beta run deploy nginx-latest \
  --image nginx:latest \
  --platform managed \
  --port=80 \
  --region ${_region} \
  --allow-unauthenticated \
  --project ${_gc_pj_id}
```
