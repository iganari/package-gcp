# basic samples

## 概要

基本的な使い方を学んでいく

## 準備

### API の有効化

+ CLI にて有効化する場合

```
gcloud beta services enable run.googleapis.com --project { Your GCP Project ID}
```

### 必要な Role

+ デプロイ時
  + Cloud Run Admin ( `roles/run.admin` )
  + Service Account User ( `roles/iam.serviceAccountUser` )
+ 新規デプロイ時に公開アクセスを許可する場合
  + :fire: Security Admin ( `roles/iam.securityAdmin` ) <- ?



+ 既存サービスに(全体)公開アクセスを許可する場合
  + `allUsers` に `roles/run.invoker` をいれる

```
gcloud run services add-iam-policy-binding SERVICE \
  --member="allUsers" \
  --role="roles/run.invoker"
```

```
デプロイ時に必要な role
https://cloud.google.com/run/docs/reference/iam/roles#additional-configuration
```

```
公開（未認証）アクセスを許可する
https://cloud.google.com/run/docs/authenticating/public
```


## Python

[python](./python/)