# GKE クラスタのアップグレード方法

## 環境変数を入れる

```
export _gcp_pj_id='Your GCP Project ID'
export _cluster_name='Your GKE Cluster Name'
export _region='asia-northeast1'
export _zone='asia-northeast1-b'
```

## コントロールプレーンのバージョンの確認とアップグレード実行

https://cloud.google.com/kubernetes-engine/docs/how-to/upgrading-a-cluster#upgrade_cp

### コントロールプレーンのバージョン確認

+ 利用可能なバージョンを確認
  + `zone` か `region` を指定する必要がある

```
gcloud beta container get-server-config --project ${_gcp_pj_id} --zone ${_zone} | head -15
```

+ クラスタの現在のバージョンを確認

```
### 全データ取得
gcloud beta container clusters describe ${_cluster_name} --project ${_gcp_pj_id} --zone ${_zone} --format json
gcloud beta container clusters describe ${_cluster_name} --project ${_gcp_pj_id} --zone ${_zone} --format yaml
```
```
### jq コマンドを使用して、バージョン情報のみを取得
gcloud beta container clusters describe ${_cluster_name} \
    --project ${_gcp_pj_id} --zone ${_zone} \
    --format json | jq .currentMasterVersion
```
```
### Ex

# gcloud beta container clusters describe ${_cluster_name} \
>     --project ${_gcp_pj_id} --zone ${_zone} \
>     --format json | jq .currentMasterVersion
"1.15.12-gke.20"
```

+ デフォルトのクラスタバージョンにアップグレード

```
gcloud beta container clusters upgrade ${_cluster_name} --master --project ${_gcp_pj_id} --zone ${_zone}
```
```
### Ex

# gcloud beta container clusters upgrade ${_cluster_name}
 --master --project ${_gcp_pj_id} --zone ${_zone}
Master of cluster [Your GCP Project ID] will be upgraded from version
[1.15.12-gke.20] to version [1.16.13-gke.401]. This operation is
long-running and will block other operations on the cluster (including
 delete) until it has run to completion.

Do you want to continue (Y/n)? Y

Upgrading [Your GCP Project ID]...
Updated [https://container.googleapis.com/v1beta1/projects/your-gcp-pj-id/zones/asia-northeast1-a/clusters/your-gke-cluster].
```

+ クラスタの現在のバージョンを確認

```
gcloud beta container clusters describe ${_cluster_name} \
    --project ${_gcp_pj_id} --zone ${_zone} \
    --format json | jq .currentMasterVersion
```
```
### Ex.

# gcloud beta container clusters describe ${_cluster_name} \
>     --project ${_gcp_pj_id} --zone ${_zone} \
>     --format json | jq .currentMasterVersion
"1.16.13-gke.401"
```

+ [割愛] デフォルト以外の特定のバージョンにアップグレード

```
export _sp_ver='1.17.12-gke.1504'
```

## ノードプールのバージョンの確認とアップグレード実行

https://cloud.google.com/kubernetes-engine/docs/how-to/upgrading-a-cluster#upgrading-nodes

+ cluster に入っている node pool の確認

```
gcloud beta container clusters describe ${_cluster_name} \
    --project ${_gcp_pj_id} \
    --zone ${_zone} \
    --format json | jq .nodePools[].name
```

+ 環境変数に入れる

```
export _node_pool_name='Your Node Pool Name'
```

+ ノードプールをコントロールプレーンと同じバージョンにアップグレードする

```
gcloud beta container clusters upgrade ${_cluster_name} \
    --node-pool ${_node_pool_name} \
    --project ${_gcp_pj_id} \
    --zone ${_zone}
```

+ ノードプールのバージョンを確認する

```
gcloud beta container clusters describe ${_cluster_name} \
    --project ${_gcp_pj_id} \
    --zone ${_zone} \
    --format json | jq '.nodePools[] | select(.name == "Your Node Pool Name") | .version'
```

以上
