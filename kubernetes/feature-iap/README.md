# GKE に IAP をつける

## 概要

GKE 上にデプロイしている Ingress に IAP( Identity-Aware Proxy ) をつける


```
Enabling IAP for GKE
https://cloud.google.com/iap/docs/enabling-kubernetes-howto
```

## 手順

### 0. 準備

GKE Cluster が作成されていて、その上に Ingress がデプロイされている前提


### 1. API の有効化

```
export _gcp_pj_id='Your GCP Project ID'
```
```
gcloud beta services enable iap.googleapis.com --project ${_gcp_pj_id}
```

### 2. OAuth consent screen の作成

WIP

### 3. OAuth credentials の作成

3-1. 左上のナビゲーションメニューから `API & Services` -> `Credentials` をクリック

IMG_01

3-2. `CREATE CREDENTIALS` -> `OAuth client ID` とクリック

IMG_02

3-3. `Application type` に `Web application` をクリック。追加で出てきた項目を埋めていき、作成する

IMG_03

IMG_04

3-4. `Client ID` と `Client Secret` が表示されるのでコピーしておく

IMG_05

+ コメント
  + Client ID は `hogehoge.apps.googleusercontent.com` の形
  + Client secret は `ランダムな文字列` の形

もしコピーし忘れても、 `OAuth 2.0 Client IDs` をクリックすれば確認できる


3-5. `OAuth 2.0 Client IDs` のところに先程作成した Client があるのでクリック

IMG_06

3-6. `Authorized redirect URIs` に以下のフォーマットで URI を入れて保存する

```
https://iap.googleapis.com/v1/oauth/clientIds/{Your Client ID}:handleRedirect
```

```
### 例
https://iap.googleapis.com/v1/oauth/clientIds/hogehoge.apps.googleusercontent.com:handleRedirect
```

IMG_07

3-7. JSON をダウンロードする

IMG_08

IMG_09

### 4. IAM の設定

IAP & Admin にて ` IAP-secured Web App User` の Role を付与する

IMG_4_01

### 5. GKE にて Secret を設定する [なぞ1]

+ GKE と認証をする

```
gcloud beta container clusters get-credentials { Your GKE Cluster's Name } \
  --region { Your GKE Cluster's Region } \
  --project ${_gcp_pj_id}
```

+ Secret の作成をする
  + 3-4 でコピーした `Client ID` と `Client secret` をいれた Secret を作る

```
kubectl create secret generic gke-ingress-iap \
  --from-literal=client_id={Your Client ID} \
  --from-literal=client_secret={Your Client secret}
```

もしくは

```
export _client_id='Your Client ID'
export _client_secret='Your Client secret'
```
```
### Base64 化


echo ${_client_id} | base64
echo ${_client_secret} | base64

---> 改行して表示される場合は 1 行にする
```

```
cat << __EOF__ > gke-ingress-iap.yaml
apiVersion: v1
kind: Secret
metadata:
  name: gke-ingress-iap
data:
  client_id: {base64 化した Client ID}
  client_secret: {base64 化した Client secret}
__EOF__
```
```
### Apply する

kubectl apply -f gke-ingress-iap.yaml
```
