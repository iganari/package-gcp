# SSL Certificates

## 概要

https://cloud.google.com/load-balancing/docs/ssl-certificates/google-managed-certs?hl=en

## 作ってみる

+ 環境変数を設定

```
### 自身の Google Cloud Project ID を入れてください
export _gc_pj_id='Your Google Cloud Project ID'

export _common='pkg-gcp'
export _region='asia-northeast1'

export _domain='iganari.org'
```

+ Google マネージド SSL 証明書の作成

```
gcloud beta compute ssl-certificates create ${_common}-cert-global \
  --description='Package GCP by iganari' \
  --domains=${_domain} \
  --global \
  --project ${_gc_pj_id}
```

## Tips

### Google-managed SSL certificates

1. Cloud Armor で IP アドレス制限をしていても、 `PROVISIONING` -> `ACTIVE`　になる
1. かならず **グローバル** になる

### Self managed SSL certificates

1. グローバルとリージョナルを選ぶことが出来る
