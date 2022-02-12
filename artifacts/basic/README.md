# Basic

## Create repository


```
export _gcp_pj_id='Your GCP Project ID'
export _region='asia-northeast1'
```

+ Create Docker Repository

```
gcloud beta artifacts repositories create my-repos \
  --repository-format docker \
  --location ${_region} \
  --project ${_gcp_pj_id}
```

+ Check Repository

```
gcloud beta artifacts repositories list --project ${_gcp_pj_id}
gcloud beta artifacts repositories describe pkg-gcp-run --location ${_region} --project ${_gcp_pj_id}
```

+ Tags URL Sample

```
${_region}-docker.pkg.dev/${_gcp_pj_id}/my-repos/my-container/images:tag
```