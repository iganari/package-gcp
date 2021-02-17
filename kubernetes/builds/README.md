# デプロイ方法

## 概要

Cloud Build を通じて、 GKE 上にデプロイする

## 実際にやってみる

+ GCP と認証する

```
gcloud auth login -q
```

### Cloud Build Trigger の Service Account に role を付与する

```
### 環境変数

export _gcp_pj_id='Your GCP Project'
```

+ Cloud Build の Service Accont を確認する

```
gcloud projects get-iam-policy ${_gcp_pj_id} | grep '@cloudbuild.gserviceaccount.com' | awk -F\: '{print $2}'
```
```
export _service_account=`gcloud projects get-iam-policy ${_gcp_pj_id} | grep '@cloudbuild.gserviceaccount.com' | awk -F\: '{print $2}'`


echo ${_service_account}
```

+ Cloud Build の Service Accont に GKE の管理者のロール( `roles/container.admin` )を付与する

```
gcloud projects add-iam-policy-binding ${_gcp_pj_id} --member=serviceAccount:${_service_account} --role='roles/container.admin'
```

### Cloud Build を設定する

+ GCP の Cloud Build にて、 `cloudbuild.yaml` を指定して Trigger を作成する

## リソースの削除

+ GKE への認証

```
gcloud beta container clusters get-credentials ${_GKE_CLUSTER_NAME} \
    --zone ${_GKE_CLUSTER_ZONE} \
    --project ${PROJECT_ID}
```

+ Service の削除

```
kubectl delete service nginx
```

+ Deployment の削除

```
kubectl delete deployment nginx
```
