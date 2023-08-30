# GKE クラスタのバージョンの確認

https://cloud.google.com/kubernetes-engine/versioning?hl=en

## Command

https://cloud.google.com/kubernetes-engine/versioning?hl=en#use_to_check_versions

```
export _release_channel='RAPID'  ## RAPID / REGULAR / STABLE
export _region='asia-northeast1'
```

+ Default version

```
gcloud beta container get-server-config \
  --region ${_region} \
  --flatten="channels" \
  --filter="channels.channel=${_release_channel}" \
  --format="yaml(channels.channel,channels.defaultVersion)"
```
```
### 例

$ gcloud beta container get-server-config \
  --region ${_region} \
  --flatten="channels" \
  --filter="channels.channel=${_release_channel}" \
  --format="yaml(channels.channel,channels.defaultVersion)"
Fetching server config for asia-northeast1
---
channels:
  channel: RAPID
  defaultVersion: 1.27.3-gke.1700
```

+ Available versions

```
gcloud beta container get-server-config \
  --region ${_region} \
  --flatten="channels" \
  --filter="channels.channel=${_release_channel}" \
  --format="yaml(channels.channel,channels.validVersions)"
```
```
### 例

$ gcloud beta container get-server-config \
  --region ${_region} \
  --flatten="channels" \
  --filter="channels.channel=${_release_channel}" \
  --format="yaml(channels.channel,channels.validVersions)"
Fetching server config for asia-northeast1
---
channels:
  channel: RAPID
  validVersions:
  - 1.27.4-gke.900
  - 1.27.3-gke.1700
  - 1.26.7-gke.500
  - 1.26.6-gke.1700
  - 1.25.12-gke.500
  - 1.25.11-gke.1700
  - 1.24.16-gke.500
  - 1.23.17-gke.10700
  - 1.23.17-gke.10000
```



