# Servcie Account について

## 概要

Cloud Build Trigger 毎に Service Account を設定することが出来る

例えば、Cloud Build Trigger 上でやる作業的に強い権限が必要(もしくは権限がほとんど要らない)な場合、Cloud Build Trigger をセキュアに運用するためには Trigger に一律な Role ではなく、Trigger 毎に Service Account を作成し、適正な Role のみを設定したほうが良い

Service Account を特別設定しない場合は Cloud Build のデフォルトの Service Account ( `{ GCP Project Number }@cloudbuild.gserviceaccount.com` ) が割り当てられる

## トリガーごとに設定

+ SA 作成

```
WIP
```

+ role
  + Service Account User ( roles/iam.serviceAccountUser ) 
  + Logs Writer ( roles/logging.logWriter )


```
WIP


https://cloud.google.com/build/docs/securing-builds/configure-user-specified-service-accounts
```


+ Trigger 作成

```
WIP
```
