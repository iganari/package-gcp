# Secret Manager

:fire: WIP :fire:

## 簡易的な使い方めも

+ GCP Project 内における API の有効化
  + `secretmanager.googleapis.com`

```
gcloud beta services enable secretmanager.googleapis.com --project {Your GCP Project ID}
```



```
gcloud beta 
```

+ リスト確認

```
gcloud beta secrets list
```
```
### Ex.

# gcloud beta secrets list --project {Your GCP Project ID}
NAME                   CREATED              REPLICATION_POLICY  LOCATIONS
MY_DB_PASSWORD         2021-05-12T14:39:04  automatic           -
```



+ リストで出てきた secret の値を取得する

```
gcloud beta secrets versions access 1 --secret {Secret Name}
```
```
### Ex.

# gcloud beta secrets versions access 1 --secret MY_DB_PASSWORD --project {Your GCP Project ID}
kore_ha_test_desu
```
