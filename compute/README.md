# Google Compute Engine

## [Ops Agent について](./ops-agent)

GCE 上の VM に　Ops Agent をインストールして利用する際のやり方や注意事項など


## VM の中から取得できる GCP のデータ 

### GCP Project ID

```
curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google"
```
```
### 例
$ curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google"
my_gcp_pj
```

### metadata

+ 公式
  + [VM メタデータにクエリを実行する](https://cloud.google.com/compute/docs/metadata/querying-metadata)

```
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/{meta key}" -H "Metadata-Flavor: Google"
```

+ `vm-role` = `base` という metadata を VM に設定している場合
 
```
### 例
$ curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/vm-role" -H "Metadata-Flavor: Google"
base
```
