# Servcie Account について

## 概要

Cloud Build Trigger 毎に Service Account を設定することが出来る

例えば、Cloud Build Trigger 上でやる作業的に強い権限が必要(もしくは権限がほとんど要らない)な場合、Cloud Build Trigger をセキュアに運用するためには Trigger に一律な Role ではなく、Trigger 毎に Service Account を作成し、適正な Role のみを設定したほうが良い

Service Account を特別設定しない場合は Cloud Build のデフォルトの Service Account ( `{ GCP Project Number }@cloudbuild.gserviceaccount.com` ) が割り当てられる

### 注意点

個別の Service Account を設定する場合、デフォルトの Cloud Build Trigger のログを書き出す GCS Bucket が使えない。これはその GCS Bucket が Google 管理の場所にあるため。

故に個別の Service Account を使う場合は、Cloud Build Trigger のログを溜める GCS Bucket から用意する必要がある

### 最低限必要なもの

+ Cloud Build のログを格納する Cloud Storage Bucket
+ Cloud Build Trigger に紐づける Service Account
  + Role
    + Logs Writer( `roles/logging.logWriter` )
    + ~~Storage Admin( `roles/storage.admin` )~~


```
https://cloud.google.com/build/docs/securing-builds/configure-user-specified-service-accounts
```


## やってみる

+ GCS Bucket の作成

```
WIP
```

+ SA 作成

```
WIP
```

+ role
  + Service Account User ( roles/iam.serviceAccountUser ) 
  + Logs Writer ( roles/logging.logWriter )



+ Trigger 作成

```
WIP
```

+ cloudbuild.yaml

```
WIP
```
