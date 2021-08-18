# ConfigMap: nginx

## 概要

nginx の VirtualHost を ConfigMap で付け足してみる

## 実際にやってみる

+ 基本的な Apache のコンテナを GKE 上に起動する
  + Deployment と Service を作る
  + Service は Type: LoadBalancer を使用する

```
kubectl apply -f main_before.yaml
```

+ Service で自動でアタッチされた IP アドレスを確認する

```
kubectl get service
```
```
### Ex.

# kubectl get service
NAME                       TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)        AGE
pkggcp-k8s-nginx-service   LoadBalancer   10.48.2.22    34.146.173.95   80:32167/TCP   71s
```

+ Web コンテンツを確認する

```
curl 34.146.173.95
```
```
### Ex.

$ curl 34.146.173.95
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

+ ConfigMap 付きのマニフェストを適用する
  + :fire: 差分を1つのファイルに追記する形が望ましいが、省略のため 2 つのファイルに分けている

```
kubectl apply -f main_after.yaml
```

+ Web コンテンツを確認する
  + 先程とは違った挙動(Google にリダイレクトされる)が実現出来ていれば OK

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

## 付録

+ [オリジナルの設定ファイル `/usr/local/apache2/conf`](./conf)
  + コンテナイメージ `httpd:2.4.46-alpine` のオリジナルの conf ディレクトリ ( `/usr/local/apache2/conf` ) をバックアップしています

## リソース削除

+ リソースを纏めて削除する

```
kubectl delete -f main_after.yaml
```
