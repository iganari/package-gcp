# metadata

## 概要

プロジェクト全体のメタデータと GCE 内のメタデータがある

## VM の中から取得できる GCP のデータ 

+ 公式
  + [VM メタデータにクエリを実行する](https://cloud.google.com/compute/docs/metadata/querying-metadata)

### metadata

+ テンプレート

```
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/{meta key}" -H "Metadata-Flavor: Google"
```

+ `vm-role` = `base` という metadata を VM に設定している場合
 
```
### 例
$ curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/vm-role" -H "Metadata-Flavor: Google"
base
```


### Google Cloud Project ID

+ コマンド

```
curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google"
```
```
### 例
$ curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google"

my_gc_pj            ### <--- GCE が所属している Google Cloud Project ID が取得できる
```
