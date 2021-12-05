# 手動で作成した永続ディスクをマウントする

## 概要

```
Provisioning regional persistent disks | Manual provisioning
https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/regional-pd#manual-provisioning
```


## やってみる

```
export _gcp_pj_id='Your GCP Project ID'
```
```
gcloud compute disks create pkg-gcp-disk \
  --size 500Gi \
  --region asia-northeast1 \
  --replica-zones asia-northeast1-b,asia-northeast1-c \
  --project ${_gcp_pj_id}
```

```
kubectl apply -f main.yaml
```
