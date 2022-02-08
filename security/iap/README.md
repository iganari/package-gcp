# Identity-Aware Proxy ( Cloud IAP )

## 概要

WIP

https://cloud.google.com/iap/docs/how-to


+ 種類
  + IAP for TCP forwarding
  + WIP

+ [プログラムによる認証](https://cloud.google.com/iap/docs/authentication-howto?hl=ja)


## API の有効化

+ 確認

```
export _gcp_pj_id='Your GCP Project ID'

### API があることを確認
gcloud beta services list --available --filter=iap --project ${_gcp_pj_id}

### API 有効化されているか否かの確認 <--- 出力されなければ有効化はされていない
gcloud beta services list --enabled --filter=iap --project ${_gcp_pj_id}
```

+ 有効化

```
gcloud beta services enable iap.googleapis.com --project ${_gcp_pj_id}
```

+ 確認

```
# gcloud beta services list --enabled --filter=iap --project ${_gcp_pj_id}
NAME                TITLE
iap.googleapis.com  Cloud Identity-Aware Proxy API
```

## IAP for TCP forwarding

[Overview of TCP forwarding](https://cloud.google.com/iap/docs/tcp-forwarding-overview)

[Using IAP for TCP forwarding](https://cloud.google.com/iap/docs/using-tcp-forwarding)

