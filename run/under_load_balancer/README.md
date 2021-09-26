# Setting up a load balancer with Cloud Run

## 概要

Google Cloud Load Balancing( GCLB ) の下に Cloud run を設置する

serverless NEG を使うところがポイント

```
### 公式ドキュメント

Setting up a load balancer with Cloud Run, App Engine, or Cloud Functions
https://cloud.google.com/load-balancing/docs/https/setting-up-https-serverless
```

## やってみる

## Cloud Run をデプロイする

```
### 公式ドキュメント

Build and deploy a Python service
https://cloud.google.com/run/docs/quickstarts/build-and-deploy/python
```

+ サンプルコードを clone する

```
git clone https://github.com/iganari/code-labo.git
cd code-labo/python/web-sample-all
```

```
export _gcp_pj_id='Your GCP Project ID'
export _region='asia-northeast1'
```
```
docker build . --tag gcr.io/${_gcp_pj_id}/ulb:latest
docker push gcr.io/${_gcp_pj_id}/ulb:latest
```

+ 1 回目
  + `--ingress internal-and-cloud-load-balancing` を使用して、アクセスを LB からのみに限定する
  + https://cloud.google.com/run/docs/securing/ingress#setting_ingress

```
gcloud run deploy ulb-run \
  --image gcr.io/${_gcp_pj_id}/ulb:latest \
  --port 5000 \
  --region ${_region} \
  --allow-unauthenticated \
  --platform managed \
  --project ${_gcp_pj_id}
```
```
### 例

# gcloud run deploy ulb-run \
>   --image gcr.io/${_gcp_pj_id}/ulb:latest \
>   --port 5000 \
>   --region ${_region} \
>   --allow-unauthenticated \
>   --platform managed \
>   --project ${_gcp_pj_id}
Deploying container to Cloud Run service [ulb-run] in project [your_gcp_pj_id] region [asia-northeast1]
✓ Deploying new service... Done.                                                                                                                                                                                                       
  ✓ Creating Revision... Deploying Revision.                                                                                                                                                                                           
  ✓ Routing traffic...                                                                                                                                                                                                                 
  ✓ Setting IAM Policy...                                                                                                                                                                                                              
Done.                                                                                                                                                                                                                                  
Service [ulb-run] revision [ulb-run-00001-zud] has been deployed and is serving 100 percent of traffic.
Service URL: https://ulb-run-iq6yvs4hkq-an.a.run.app
```

![](./01.png)





+ アップデート

```
gcloud run services update ulb-run \
  --image gcr.io/${_gcp_pj_id}/ulb:latest \
  --port 5000 \
  --region ${_region} \
  --platform managed \
  --ingress internal-and-cloud-load-balancing \
  --project ${_gcp_pj_id}
```

![](./02.png)


## GCLB で使用する External IP アドレスを予約する

+ gcloud コマンドで実施

```
gcloud compute addresses create ulb-ip \
  --ip-version=IPV4 \
  --global \
  --project ${_gcp_pj_id}
```

+ 予約した IP アドレスを確認

```
gcloud compute addresses describe ulb-ip \
  --format="get(address)" \
  --global \
  --project ${_gcp_pj_id}
```

## ドメインを決める

+ 今回は以下のドメインを使用します

![](./03.png)

## Google-managed SSL certificate を作る

```
gcloud compute ssl-certificates create ulb-cer \
  --domains ulb.iganari.xyz \
  --global \
  --project ${_gcp_pj_id}
```

## serverless NEG を作る

```
gcloud compute network-endpoint-groups create ulb-serverlessneg \
  --region ${_region} \
  --network-endpoint-type serverless  \
  --cloud-run-service ulb-run \
  --project ${_gcp_pj_id}
```

+ backend service を作る

```
gcloud compute backend-services create ulb-backendservice \
  --global \
  --project ${_gcp_pj_id}
```

+ serverless NEG を backend service の backend に登録する

```
gcloud compute backend-services add-backend ulb-backendservice \
  --global \
  --network-endpoint-group ulb-serverlessneg \
  --network-endpoint-group-region ${_region} \
  --project ${_gcp_pj_id}
```

+ URL map を作る

```
gcloud compute url-maps create ulb-urlmap \
  --default-service ulb-backendservice \
  --project ${_gcp_pj_id}
```

+ HTTPS target proxy を作る
  + 先に作った Google-managed SSL certificate も使用する

```
gcloud compute target-https-proxies create ulb-httpstargetproxy \
  --ssl-certificates ulb-cer \
  --url-map ulb-urlmap \
  --project ${_gcp_pj_id}
```

+ global forwarding rule を作る
  + HTTPS load balancer を作る

```
gcloud compute forwarding-rules create ulb-httpsforwadingrule \
  --address ulb-ip \
  --target-https-proxy ulb-httpstargetproxy \
  --global \
  --ports 443 \
  --project ${_gcp_pj_id}
```

+ Web ブラウザから確認する

![](./04.png)

![](./05.png)


## リソースの削除

```
gcloud compute forwarding-rules delete ulb-httpsforwadingrule \
  --global \
  --project ${_gcp_pj_id} \
  -q

gcloud compute target-https-proxies delete ulb-httpstargetproxy \
  --project ${_gcp_pj_id} \
  -q

gcloud compute url-maps delete ulb-urlmap \
  --project ${_gcp_pj_id} \
  -q

gcloud compute backend-services delete ulb-backendservice \
  --global \
  --project ${_gcp_pj_id} \
  -q

gcloud compute network-endpoint-groups delete ulb-serverlessneg \
  --region ${_region} \
  --project ${_gcp_pj_id} \
  -q

gcloud compute ssl-certificates delete ulb-cer \
  --global \
  --project ${_gcp_pj_id} \
  -q

gcloud run services delete ulb-run \
  --region ${_region} \
  --project ${_gcp_pj_id} \
  -q
```








