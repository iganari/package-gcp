# Cloud Run にまつわる gcloud

## リビジョンについて

### リビジョンのリストを表示

```
export _gc_pj_id='Your Google Cloud Project'
export _region='asia-northeast1'
export _run_service='Your Cloud Run Service Name'
```




```
### 全部のリストを取得
gcloud beta run revisions list --service ${_run_service} --region ${_region} --project ${_gc_pj_id}


### ステータスが Active のみを表示
TBD
```

+ 調査中

```
gcloud beta run revisions list --service ${_run_service} --region ${_region} --project ${_gc_pj_id} --format json | jq .[].status.conditions[].type
```


+ リビジョン名のみを抜き出す

```
gcloud beta run revisions list --service ${_run_service} --region ${_region} --project ${_gc_pj_id} --format json | jq -r .[].metadata.name
```
```
### 例

$ gcloud beta run revisions list --service ${_run_service} --region ${_region} --project ${_gc_pj_id} --format json | jq -r .[].metadata.name
hogehogerun-00009-xj5
hogehogerun-00008-k9t
hogehogerun-00007-2b7
hogehogerun-00006-mtb
hogehogerun-00005-7d7
hogehogerun-00004-b4c
hogehogerun-00003-42f
hogehogerun-00002-jgq
hogehogerun-b9cc30f
```
