# Google Compute Engine

## [Ops Agent について](./ops-agent)

GCE 上の VM に　Ops Agent をインストールして利用する際のやり方や注意事項など


## VM の中から metadata を取得できる

+ 公式
  + [VM メタデータにクエリを実行する](https://cloud.google.com/compute/docs/metadata/querying-metadata)


+ `vm-role` = `base` という metadata を VM に設定している場合
 
```
$ curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/vm-role" -H "Metadata-Flavor: Google"
base
```
