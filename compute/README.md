# Google Compute Engine

## [Ops Agent について](./ops-agent)

GCE 上の VM に　Ops Agent をインストールして利用する際のやり方や注意事項など

## Patch について

TBD

## 外部 IP アドレスの変更方法

https://cloud.google.com/compute/docs/ip-addresses/reserve-static-external-ip-address

## 目次

TBD

## Tips

- VM in VM について (VM のネスト)
  - [ネストされた仮想化について](https://cloud.google.com/compute/docs/instances/nested-virtualization/overview?hl=en)

- GCE 内から Project ID を取得する
  - metadata から取得が可能
  - https://cloud.google.com/compute/docs/metadata/overview?hl=en

```
curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google"
```























