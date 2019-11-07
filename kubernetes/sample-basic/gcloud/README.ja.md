# [WIP] GKE Sample using gcloud command

## 参考 URL

+ 公式チュートリアル
  + https://cloud.google.com/kubernetes-engine/docs/tutorials/

## Deploying a containerized web application

+ 公式ドキュメント
  + https://cloud.google.com/kubernetes-engine/docs/tutorials/hello-app


### Option A: Use Google Cloud Shell

+ GKE を操作出来るようにパッケージをインストールする

```
gcloud components install kubectl
```

### Step 1: Build the container image

+ サンプルソースコードを GitHub から取得する

```
git clone https://github.com/GoogleCloudPlatform/kubernetes-engine-samples
cd kubernetes-engine-samples/hello-app
```

+ プロジェクトの設定

```
export _pj='iganari-gke-test'

export PROJECT_ID=${_pj}
```


+ Docker コンテナのイメージを作成する

```
docker build -t gcr.io/${_pj}/hello-app:v1 .
```

+ Docker イメージの確認

```
docker images
```
```
### 例

$ docker images
REPOSITORY                          TAG                 IMAGE ID            CREATED             SIZE
gcr.io/ca-igarashi-test/hello-app   v1                  ad8e83f42b58        6 seconds ago       11.4MB
```

### Step 2: Upload the container image

+ 認証

```
gcloud auth configure-docker
```

+ GCR に対して、 Docker イメージを push する

```
docker push gcr.io/${_pj}/hello-app:v1
```

### Step 3: Run your container locally (optional)

+ Cloud Shell 上だと難しいのでパス

### Step 4: Create a container cluster

+ 最低限のプロパティを設定する

```
gcloud config set project ${_pj}
gcloud config set compute/zone asia-northeast1-a
```

+ GKE 作成
  + default のネットワークが存在する場合

```
gcloud container clusters create hello-cluster --num-nodes=2
```

+ GKE 作成
  + :warning: default のネットワークが存在しない場合

+ VPC ネットワーク作成

```
### めんどくさい人向け(非推奨)

gcloud compute networks create auto-network --subnet-mode auto
```

```
### 日本 に限定して VPC ネットワークの作成
### これは真剣にやる必要があるので後回し

gcloud compute networks create gke-sample --subnet-mode custom

gcloud compute networks subnets create gke-sample-sb-us-central  --network gke-sample --region us-central1  --range 192.168.1.0/24
gcloud compute networks subnets create gke-sample-sb-europe-west --network gke-sample --region europe-west1 --range 192.168.2.0/24
gcloud compute networks subnets create gke-sample-sb-asia-east   --network gke-sample --region asia-east1   --range 192.168.3.0/24


gcloud container clusters create hello-cluster --num-nodes=2 --network=gke-sample --subnetwork=gke-sample-sb-asia-east
>> 要確認



### 一旦削除

gcloud compute networks subnets delete gke-sample-sb-us-central  --region us-central1
gcloud compute networks subnets delete gke-sample-sb-europe-west --region europe-west1
gcloud compute networks subnets delete gke-sample-sb-asia-east   --region asia-east1

gcloud compute networks delete gke-sample
```


---> ここまでで GKE 作成完了
 

 + GKE に使われている node (GCE) の確認

```
gcloud compute instances list
```

### Step 5: Deploy your application

+ deployment の作成

```
kubectl create deployment hello-web --image=gcr.io/${PROJECT_ID}/hello-app:v1
```

+ Pods の確認

```
kubectl get pods
```

### Step 6: Expose your application to the Internet

+ 外部IPアドレスをつけてあげる
  + どこに? service では無く??

```
kubectl expose deployment hello-web --type=LoadBalancer --port 80 --target-port 8080
```

+ 確認

```
kubectl get service
```
```
### 準備中

$ kubectl get service
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
hello-web    LoadBalancer   10.55.244.211   <pending>     80:31119/TCP   28s
kubernetes   ClusterIP      10.55.240.1     <none>        443/TCP        6m57s
```
```
### 準備完了

$ kubectl get service
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
hello-web    LoadBalancer   10.55.244.211   34.84.161.130   80:31119/TCP   87s
kubernetes   ClusterIP      10.55.240.1     <none>          443/TCP        7m56s
```

### Step 7: Scale up your application

+ レプリカを増やす

```
kubectl scale deployment hello-web --replicas=3
```

+ 確認

```
kubectl get deployment hello-web
```
```
$ kubectl get deployment hello-web
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
hello-web   3/3     3            3           55m
```

+ Pods の確認

```
kubectl get pods
```
```
$ kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
hello-web-569dc47c5b-4svdz   1/1     Running   0          56m
hello-web-569dc47c5b-twgmt   1/1     Running   0          58s
hello-web-569dc47c5b-v2rrs   1/1     Running   0          58s
```

### Deploy a new version of your app

```
docker build -t gcr.io/${PROJECT_ID}/hello-app:v2 .
```
```
docker push gcr.io/${PROJECT_ID}/hello-app:v2
```
```
kubectl set image deployment/hello-web hello-app=gcr.io/${PROJECT_ID}/hello-app:v2
```

## Cleaning up

+ Service の削除
  + 外部IPアドレス含む

```
kubectl delete service hello-web
```

+ GKE のクラスター削除

```
gcloud container clusters delete hello-cluster
```