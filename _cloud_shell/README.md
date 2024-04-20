# Cloud Shell

## 概要

GCP コンソール上で使用できる

## Cloud Shell の IP アドレスを取得する

```
wget -qO - http://ipecho.net/plain
```


## Project ID を取得する

+ デフォルトで設定さてれいてる Google Cloud Project ID を取得

```
export PROJECT_ID=$(gcloud config get-value project | sed '2d')
```
