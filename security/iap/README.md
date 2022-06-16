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


## 制限事項

### Q. IAP のセッションの永続時間は?

A. 非アクティブ状態が 1 時間続くと自動で切れる

```
Known limitations | Connection length
https://cloud.google.com/beyondcorp-enterprise/docs/securing-virtual-machines#known_limitations
```

## Tips


+ IAP を設定直後に Aouth 画面がなかなか反映しない場合 

---> IAM が強制号なので5分くらいは待つ。それでもだめな場合は以下を末尾につける

```
https://hogehoge.an.r.appspot.com/
```

```
/_gcp_iap/clear_login_cookie
```

```
https://hogehoge.an.r.appspot.com/_gcp_iap/clear_login_cookie
```
