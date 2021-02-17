# デプロイ方法

+ GCP と認証する

```
gcloud auth login -q
```

```
### 環境変数

export _gcp_pj_id='ca-corporate-website-dev2'
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
