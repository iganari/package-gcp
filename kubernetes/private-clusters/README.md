# 限定公開クラスタの設定 (Creating a private cluster)

## これは何？

公式ドキュメント

+ https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters

どんなものなの??

+ 他の VPC ネットワークから隔離したネットワーク上に K8s を展開します
+ 限定公開クラスタ内の Node 及び、 Pod から外にアクセスする場合は、 ロードバランサ経由で外部からアクセスを受信出来ます。


## 準備

+ GCP のアカウント作成

```
他の参考資料に任せます
```

+ gcloud には 設定のセットをローカルに保持して管理することが出来ます。
  + [gcloud config configurations]
  + ここではプロジェクトを同じ名前の設定を作成する例を記載します。
  + GCP 上で以下のようなステータスで作成していきます。
    + プロジェクト名
      + iganari-gke-private-clusters
    + region
      + us-central1
    + zone
      + us-central1-a


```
export _pj='iganari-gke-sample-basic'

gcloud config configurations create ${_pj}
gcloud config configurations list

gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a
gcloud config set project ${_pj}

gcloud auth login
```

```
$ gcloud config configurations list
NAME                      IS_ACTIVE  ACCOUNT                     PROJECT                   DEFAULT_ZONE  DEFAULT_REGION
iganari-gke-sample-basic  True       igarashi.toru@cloud-ace.jp  iganari-gke-sample-basic  us-central1   us-central1-a
```

## Creating a private cluster with limited access to the public endpoint

+ チュートリアル通りに GKE を作ってみる
  + `n1-standard-1` が 9 台立ち上がる!!

```
gcloud container clusters create private-cluster-0 \
  --create-subnetwork name=my-subnet-0 \
  --enable-master-authorized-networks \
  --enable-ip-alias \
  --enable-private-nodes \
  --master-ipv4-cidr 172.16.0.0/28 \
  --no-enable-basic-auth \
  --no-issue-client-certificate
```

+ 一旦、削除

```
gcloud container clusters delete private-cluster-0
```


+ 上記をミニマムで作ってみる
  + `n1-standard-1` が 3 台 + preemptible インスタンスを使用する
  + `gcloud beta` コマンドを使用します

```
gcloud beta container clusters create private-cluster-0 \
  --create-subnetwork name=my-subnet-0 \
  --enable-master-authorized-networks \
  --enable-ip-alias \
  --enable-private-nodes \
  --master-ipv4-cidr 172.16.0.0/28 \
  --no-enable-basic-auth \
  --no-issue-client-certificate \
  --num-nodes=1 \
  --release-channel stable \
  --preemptible 
```

+ Cloud Shell からの疎通を許可する

```
dig +short myip.opendns.com @resolver1.opendns.com
```
```
### 例

$ dig +short myip.opendns.com @resolver1.opendns.com
104.199.171.167
```
```
gcloud container clusters update private-cluster-0 \
    --zone us-central1-c \
    --enable-master-authorized-networks \
    --master-authorized-networks [EXISTING_AUTH_NETS],[SHELL_IP]/32
```
```
### 例

$ gcloud container clusters update private-cluster-0 \
    --region us-central1 \
    --enable-master-authorized-networks \
    --master-authorized-networks 104.199.171.167/32
```

+ GKE との認証を gcloud コマンド経由で行います

```
gcloud container clusters get-credentials private-cluster-0 \
    --region us-central1 \
    --project ${_pj}
```

+ Node の確認

```
kubectl get nodes
```
```
### 例

$ kubectl get nodes
NAME                                               STATUS   ROLES    AGE   VERSION
gke-private-cluster-0-default-pool-5bb7017b-x7lf   Ready    <none>   32m   v1.13.11-gke.14
gke-private-cluster-0-default-pool-71736f9d-x5fx   Ready    <none>   32m   v1.13.11-gke.14
gke-private-cluster-0-default-pool-96dab18f-t59k   Ready    <none>   32m   v1.13.11-gke.14
```

## CloudNAT 試す

ドキュメント

+ https://cloud.google.com/nat/docs/gke-example

```
gcloud compute routers create nat-router \
  --network default \
  --region us-central1
```
```
gcloud compute routers nats create nat-config \
    --router-region us-central1 \
    --router nat-router \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips
```
```
gcloud compute firewall-rules create allow-ssh-1113 \
    --network default \
    --allow tcp:22
```

### Step 5: Log into node and confirm that it cannot reach the Internet

```
gcloud compute instances list
```
```
### 例

$ gcloud compute instances list
NAME                                              ZONE           MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP  STATUS
gke-private-cluster-0-default-pool-5bb7017b-x7lf  us-central1-a  n1-standard-1  true         10.97.28.4                RUNNING
gke-private-cluster-0-default-pool-71736f9d-x5fx  us-central1-c  n1-standard-1  true         10.97.28.2                RUNNING
gke-private-cluster-0-default-pool-96dab18f-t59k  us-central1-f  n1-standard-1  true         10.97.28.3                RUNNING
```
```
### 例

$ gcloud compute ssh gke-private-cluster-0-default-pool-5bb7017b-x7lf \
    --zone us-central1-a \
    --tunnel-through-iap
```

## Pod を作ってみる

```
vim pod-nginx.yaml
```
```
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
    - name: nginx-container
      image: nginx
      ports:
      - containerPort: 80
```

```
kubectl create -f pod-nginx.yaml
```
```
### 例

$ kubectl create -f pod-nginx.yaml
pod/nginx-pod created

$ kubectl get pods
NAME        READY   STATUS    RESTARTS   AGE
nginx-pod   1/1     Running   0          30s

$ kubectl exec -it nginx-pod /bin/bash
```

## クラスタの削除

```
gcloud container clusters delete private-cluster-0
```
