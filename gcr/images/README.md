# Repositories



## コマンド

コンテナイメージのリスト

```
gcloud container images list --project ${_gcp_pj_id}
```

+ 削除

```
gcloud container images delete <IMAGE_NAME> --force-delete-tags --project ${_gcp_pj_id}
````

+ 一括削除

```
export _my_image_name='want to delete iamge name'


for i in `gcloud container images list-tags gcr.io/${_gcp_pj_id}/${_my_image_name} --project ${_gcp_pj_id} | awk 'NR>1 {print $1}'`
  do
    gcloud container images delete gcr.io/${_gcp_pj_id}/${_my_image_name}@sha256:$i --force-delete-tags --project ${_gcp_pj_id} -q
  done
```
