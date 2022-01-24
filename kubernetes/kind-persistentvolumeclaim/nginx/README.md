# PersistentVolumeClaim: nginx


```
https://github.com/GoogleCloudPlatform/kubernetes-engine-samples/tree/master/wordpress-persistent-disks
```

## 実行方法

### 認証

+ GKE Cluster との認証

```

```

### GKE Cluster にデプロイ

+ GKE Cluster にデプロイ

```
kubectl apply -f nginx.yaml
```

+ 確認コマンド

```
kubectl get statefulset
```
```
kubectl get service
```
```
kubectl get pod
```

### HTML のサンプルを置く

+ Pod の一つにログイン

```
kubectl exec -it {POD 名} /bin/ash
```

+ Pod の中での作業

```
cd /usr/share/nginx/html
```
```
apk add git
git clone https://github.com/iganari/package-html-css.git
cp -r package-html-css/04/* .
```
```
exit
```

## リソースの削除

+ リソースの削除

```
kubectl delete -f nginx.yaml
```
