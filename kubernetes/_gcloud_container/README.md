#  gcloud container について

## gcloud beta container node-pools describe

+ 出力を JSON にする場合
  + `--format`

```
gcloud beta container node-pools describe {{ Node Pool Name }} \
  --cluster {{ GKE Cluster Name }} \
  --region {{ GKE Cluster Region }} \
  --project {{ Your Google Cloud Project ID }} --format json
```


