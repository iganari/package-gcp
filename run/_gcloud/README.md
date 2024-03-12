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
gcloud beta run revisions list \
  --service ${_run_service} \
  --region ${_region} \
  --project ${_gc_pj_id} \
  --format json | \
  jq -r .[].metadata.name
```
```
### 例

$ gcloud beta run revisions list \
  --service ${_run_service} \
  --region ${_region} \
  --project ${_gc_pj_id} \
  --format json | \
  jq -r .[].metadata.name

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

+ 特定のリビジョンを削除する
  + Cloud Run の Service 名は不要

```
export _run_revision_name='削除したい Revision Name'


gcloud beta run revisions delete ${_run_revision_name} \
  --region ${_region} \
  --platform managed \
  --project ${_gc_pj_id} \
  --quiet
```
```
$ gcloud beta run revisions delete ${_run_revision_name} \
  --region ${_region} \
  --platform managed \
  --project ${_gc_pj_id} \
  --quiet

Deleting [hogehogerun-b9cc30f]...done.
Deleted revision [hogehogerun-b9cc30f]
```

## ケース1

+ 条件
  + tag は一切使っていない場合

+ 全てのリビジョンを取得

```
export _gc_pj_id='Your Google Cloud Project'
export _region='Your Cloud Run Region'
export _run_service='Your Cloud Run Service Name'


gcloud beta run revisions list \
  --service ${_run_service} \
  --region ${_region} \
  --project ${_gc_pj_id} \
  --format json | \
  jq -r .[].metadata.name
```

+ 不要なリビジョンをすべて削除
  + やや強引
  + TODO: jq でもっとスマートに書きなしたい

```
for i in `gcloud beta run revisions list \
  --service ${_run_service} \
  --region ${_region} \
  --project ${_gc_pj_id} | \
  grep -v "yes" | \
  awk 'NR>=2 {print $2}'` ;\
  do gcloud beta run revisions delete ${i} --region ${_region} --platform managed --project ${_gc_pj_id} --quiet ;\
  done
```



