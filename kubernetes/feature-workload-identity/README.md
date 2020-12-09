# Workload Identity を試す

## やること

5 ステップある

+ [GKE で Workload Identity を有効にする](./README.md#gke-で-workload-identity-を有効にする)
+ [Kubernetes の Service Account を作成](./README.md#kubernetes-の-service-account-を作成)
+ [GCP の Service Account を作成](./README.md#gcp-の-service-account-を作成)
+ [GCP の Service Account に Workload Identity の role を付与する](./README.md#gcp-の-service-account-に-workload-identity-の-role-を付与する)
+ [Kubernetes の Service Account と GCP の Service Account を紐付ける](./README.md#kubernetes-の-service-account-と-gcp-の-service-account-を紐付ける)

## GKE で Workload Identity を有効にする

+ 環境変数

```
export _gcp_pj_id='Your GCP Project ID'
export _cluster_name='workload-identity-test'
```

+ 新規クラスターを作る場合

```
gcloud container clusters create ${_cluster_name} \
  --workload-pool=${_gcp_pj_id}.svc.id.goog \
  --project ${_gcp_pj_id}
```

+ 既存のクラスタで Workload Identity を有効にする場合

```
gcloud container clusters update ${_cluster_name} \
  --workload-pool=${_gcp_pj_id}.svc.id.goog \
  --project ${_gcp_pj_id}
```

## Kubernetes の Service Account を作成

+ 環境変数

```
export _k8s_namespace='default'
export _k8s_sa_name='my-k8s-serviceaccount'
```

+ 作成コマンド

```
kubectl create serviceaccount --namespace ${_k8s_namespace} ${_k8s_sa_name}
```

## GCP の Service Account を作成

+ 環境変数

```
export _gcp_sa_name='my-gcp-serviceaccount'
```

+ 作成コマンド

```
gcloud iam service-accounts create ${_gcp_sa_name}
```

## GCP の Service Account に Workload Identity の role を付与する

```
gcloud iam service-accounts add-iam-policy-binding \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:${_gcp_pj_id}.svc.id.goog[${_k8s_namespace}/${_k8s_sa_name}]" \
  ${_gcp_sa_name}@${_gcp_pj_id}.iam.gserviceaccount.com
```

## Kubernetes の Service Account と GCP の Service Account を紐付ける

+ YAML の作成

```
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    iam.gke.io/gcp-service-account: ${_gcp_sa_name}@${_gcp_pj_id}.iam.gserviceaccount.com
  name: ${_k8s_sa_name}
  namespace: ${_k8s_namespace}
```


## 確認方法

+ gcloud コマンドが入っているコンテナを立ち上げる

```
kubectl run test --image=gcr.io/cloud-builders/gcloud config list
```

---> これで先程作成した GCP 上の Service Account の設定が見えれば OK

## 参考 URL

+ [公式] Using Workload Identity
  + https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity

+ Workload Identityを試す
  + https://qiita.com/atsumjp/items/9df1f4e18bea164f95fe
