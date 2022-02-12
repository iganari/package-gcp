# Python

## Local Check

```
export _container_image_name='pkg-gcp-run-basic'
```

+ Build Container

```
docker build . --file Dockerfile --tag ${_container_image_name}
```

+ Local Run

```
docker run -d -p 8080:80 --name pkg-gcp-run-basic ${_container_image_name}
```

+ Check cURL

```
curl 0.0.0.0:8080
```
```
## Sample

$ curl 0.0.0.0:8080
Hello World!! :D
```

## Upload to Container Image

```
export _gcp_pj_id='Your GCP PJ ID'
export _region='asia-northeast1'
```

+ Create Repository of Artifact Registry

```
gcloud beta artifacts repositories create pkg-gcp-run \
  --repository-format docker \
  --location ${_region} \
  --project ${_gcp_pj_id}
```

+ Configure Docker

```
gcloud auth configure-docker asia-northeast1-docker.pkg.dev
```

+ Push Container Image to Repository

```
docker build . --file Dockerfile --tag ${_region}-docker.pkg.dev/${_gcp_pj_id}/pkg-gcp-run/${_container_image_name}:v1
docker push ${_region}-docker.pkg.dev/${_gcp_pj_id}/pkg-gcp-run/${_container_image_name}:v1
```

## Deploy to Cloud Run

```
export _run_service='pkg-gcp-run-basic'
```

+ Allow ALL User

```
gcloud beta run deploy ${_run_service} \
  --image ${_region}-docker.pkg.dev/${_gcp_pj_id}/pkg-gcp-run/${_container_image_name}:v1 \
  --port=80 \
  --region ${_region} \
  --allow-unauthenticated \
  --project ${_gcp_pj_id}
```

+ Only Authorized User

```
gcloud beta run deploy ${_run_service} \
  --image ${_region}-docker.pkg.dev/${_gcp_pj_id}/pkg-gcp-run/${_container_image_name}:v1 \
  --port=80 \
  --region ${_region} \
  --no-allow-unauthenticated \
  --project ${_gcp_pj_id}
```

## Check

+ Check URL

```
gcloud beta run services describe ${_run_service} --region ${_region} --project ${_gcp_pj_id}
```

+ Only URL

```
gcloud beta run services describe ${_run_service} --region ${_region} --project ${_gcp_pj_id} --format json | jq .status.url -r
```
```
### Sample

$ gcloud beta run services describe ${_run_service} --region ${_region} --project ${_gcp_pj_id} --format json | jq .status.url -r
https://pkg-gcp-run-basic-ed5v7cgalq-an.a.run.app
```

```
$ curl https://pkg-gcp-run-basic-ed5v7cgalq-an.a.run.app/
Hello World!! :D
```

### ScreenShot

![](./01.png)

![](./02.png)

![](./03.png)

## Shutdown

+ Delete Run Service

```
gcloud beta run services delete ${_run_service} \
  --region ${_region} \
  --project ${_gcp_pj_id}
```

+ Delete Repository of Artifact Registry

```
gcloud beta artifacts repositories delete pkg-gcp-run \
  --location ${_region} \
  --project ${_gcp_pj_id}
```

+ Delete Local Container Image

```
docker stop  ${_container_image_name}:v1
docker rm -f ${_container_image_name}:v1
docker rmi   ${_container_image_name}:v1
docker rmi   ${_region}-docker.pkg.dev/${_gcp_pj_id}/pkg-gcp-run/${_container_image_name}:v1
```
