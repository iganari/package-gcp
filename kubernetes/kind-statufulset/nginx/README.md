# StatefulSet: nginx

## ドキュメント

+ [参考ドキュメント] StatefulSets
    + https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

## 実行方法

+ GKE Cluster との認証

```

```

+ GKE Cluster にデプロイ

```
kubectl apply -f nginx.yaml
```

+ リソースの削除

```
kubectl delete -f nginx.yaml
```
```
kubectl get pvc | awk 'NR>1 {print $1}' | xargs kubectl delete pvc
kubectl get pv | awk 'NR>1 {print $1}' | xargs kubectl delete pv
```