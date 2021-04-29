# ConfigMap: Apache

## WIP

+ 基本的な Apache のコンテナを立ち上げる

```
kubectl apply -f main_before.yaml
```

+ IP アドレスの確認

```
kubectl get service
```
```
### Ex.

# kubectl get service
NAME                        TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S)        AGE
kubernetes                  ClusterIP      10.60.0.1     <none>         443/TCP        142d
pkggcp-k8s-apache-service   LoadBalancer   10.60.14.71   34.85.81.205   80:30085/TCP   113s
```

+ コンテンツの確認

```
curl 34.85.81.205
```
```
### Ex.

# curl 34.85.81.205
<html><body><h1>It works!</h1></body></html>
```

+ ConfigMap 付きにする

```
kubectl apply -f main_after.yaml
```

+ コンテンツの確認

```
curl 34.85.81.205
```
```
### Ex.

# curl 34.85.81.205
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>301 Moved Permanently</title>
</head><body>
<h1>Moved Permanently</h1>
<p>The document has moved <a href="https://www.google.com">here</a>.</p>
</body></html>
```


## リソース削除

```
kubectl delete -f main_after.yaml
```
