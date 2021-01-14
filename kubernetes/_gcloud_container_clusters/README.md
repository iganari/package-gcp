# GKE 特有のコマンドについて

+ 基本系

```
gcloud container clusters
```

+ [get-credentials](./README.md#get-credentials)
+ [resize](./README.md#resize)

## get-credentials

GKE との認証を行うコマンド

```
### Zonal

gcloud container clusters get-credentials {cluster-name} \
    --zone {GKE Zone} \
    --project {Your GCP Project}
```
```
### Regional

gcloud container clusters get-credentials {cluster-name} \
    --region {GKE Region} \
    --project {Your GCP Project}
```

## resize

Cluster のノードプールのサイズを変更するコマンド

```
### Zonal

gcloud container clusters resize {cluster-name} \
    --zone {GKE Zone} \
    --node-pool {pool-name} \
    --num-nodes {num-nodes} \
    --project {Your GCP Project}
```
```
### Regional

gcloud container clusters resize {cluster-name} \
    --region {GKE Region} \
    --node-pool {pool-name} \
    --num-nodes {num-nodes} \
    --project {Your GCP Project}
```
