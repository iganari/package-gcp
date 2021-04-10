# StatefulSet: nginx

## ドキュメント

+ [参考ドキュメント] StatefulSets
    + https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

## 実行方法

### 認証

+ GKE Cluster との認証

```
gcloud container clusters get-credentials {Your GKE Cluster}
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

これをすべての Pod で行う = nginx の場合は非効率である

## リソースの削除

+ リソースの削除

```
kubectl delete -f nginx.yaml
```

+ persistentVolumeClaim の削除
    + StatefulSet の場合はこの作業が必要

```
kubectl get pvc | awk 'NR>1 {print $1}' | xargs kubectl delete pvc
```
