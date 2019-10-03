# Ingress によるバックエンド サービスの構成

:warning: 2019/10 時点で実行確認をしています

## 公式ドキュメント

https://cloud.google.com/kubernetes-engine/docs/how-to/configure-backend-service

## 趣旨

+ 公式ドキュメントに沿って実行していくと、不要な Backend services が出来るので、それを作らないようにマニュフェストを修正

## 実行方法

### 準備

+ gcloud コマンドによる認証

```
gcloud auch login
```

+ GKE を起動するプロジェクトを設定

```
gcloud config set project ${YOUR_PROJECT}
```

+ GKE の Zone を予め設定

```
gcloud config set compute/zone asia-northeast1-a
```

### Kubernetes Engine クラスタの作成

```
export cl_name='sp-2003'
echo ${cl_name}
```

+ テストのため、 Node は2台で起動する

```
gcloud beta container clusters create ${cl_name} --num-nodes=2
```

+ クラスタの認証情報を取得

```
gcloud beta container clusters get-credentials ${cl_name}
```

+ Node の確認

```
kubectl get node -o wide
```

### Deployment を作成する 

WIP

















