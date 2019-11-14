# Creating a private cluster

公式ドキュメント

+ https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters

## 準備

+ GCP のアカウント作成

```
他の参考資料に任せます
```

+ gcloud には 設定のセットをローカルに保持して管理することが出来ます。
  + [gcloud config configurations]
  + ここではプロジェクトを同じ名前の設定を作成する例を記載します。
  + GCP 上のプロジェクト名 = iganari-gke-sample-basic とします。

```
export _pj='iganari-gke-sample-basic'

gcloud config configurations create ${_pj}
gcloud config configurations list


gcloud config set compute/zone us-central1
gcloud config set compute/region us-central1-a
gcloud config set project ${_pj}

gcloud auth login
```
```
gcloud auth application-default login
```

```
$ gcloud config configurations list
NAME                      IS_ACTIVE  ACCOUNT                     PROJECT                   DEFAULT_ZONE  DEFAULT_REGION
iganari-gke-sample-basic  True       igarashi.toru@cloud-ace.jp  iganari-gke-sample-basic  us-central1   us-central1-a
```


