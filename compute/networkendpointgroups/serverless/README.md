# Serverless NEG

## Hands On Serverless Network Endpoint Group

https://github.com/iganari/handson-serverless-neg

## 作成方法

:warning: Cloud Console だと Serverless NEG は作成出来ないので CLI か API 経由で作成する必要がある

### CLI

+ 基本形

```
gcloud beta compute network-endpoint-groups create {{ serverless-neg-name }} \
  --region {{ region }} \
  --network-endpoint-type SERVERLESS \
  --cloud-run-service {{ run_service }} \
  --project {{ Google Cloud Project ID }}
```

+ Tag を指定
  + `--cloud-run-tag` で Cloud Run の特定のリビジョンに付与したタグを指定する

```
gcloud beta compute network-endpoint-groups create {{ serverless-neg-name }} \
  --region {{ region }} \
  --network-endpoint-type SERVERLESS \
  --cloud-run-service {{ run_service }} \
  --cloud-run-tag hogehoge \
  --project {{ Google Cloud Project ID }}
```