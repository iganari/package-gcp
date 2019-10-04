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

### Repository の clone

```
git clone git@github.com:iganari/package-gcp.git
cd package-gcp
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

+ 実行

```
kubectl apply -f my-bsc-deployment.yaml
```

+ 確認

```
kubectl get deployment
```
```
### 例

$ kubectl get deployment
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
my-bsc-deployment   2/2     2            2           55s
```

### backendconfig を作る

+ 実行

```
kubectl apply -f my-bsc-backendconfig.yaml
```

+ 確認

```
kubectl get backendconfig
```
```
### 例

$ kubectl get backendconfig
NAME                   AGE
my-bsc-backendconfig   31s
```

### サービスの作成

+ 実行

```
kubectl apply -f my-bsc-service.yaml
```

+ 確認

```
kubectl get service
```

```
### 例


$ kubectl get service
NAME             TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
kubernetes       ClusterIP   10.39.240.1   <none>        443/TCP        107m
my-bsc-service   NodePort    10.39.251.4   <none>        80:32093/TCP   8s
```

### Ingress の作成

+ 実行

```
kubectl apply -f my-bsc-ingress.yaml
```

+ 確認

```
kubectl get ingress
```
```
### 例

$ kubectl get ingress
NAME             HOSTS   ADDRESS   PORTS   AGE
my-bsc-ingress   *                 80      4s
```

## 実験後

### k8s 削除

```
kubectl delete ingress my-bsc-ingress
kubectl delete service my-bsc-service
kubectl delete backendconfig my-bsc-backendconfig
kubectl delete deployment my-bsc-deployment
```

### GKE 削除

```
gcloud beta container clusters delete ${cl_name}
```
