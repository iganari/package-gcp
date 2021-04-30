# ConfigMap: Apache

## 概要

Apache の VirtualHost を ConfigMap で付け足してみる

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
NAME                        TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S)        AGE
kubernetes                  ClusterIP      10.60.0.1     <none>         443/TCP        142d
pkggcp-k8s-apache-service   LoadBalancer   10.60.14.71   34.85.81.205   80:30085/TCP   113s
```

+ Web コンテンツを確認する

```
curl 34.85.81.205
```
```
### Ex.

# curl 34.85.81.205
<html><body><h1>It works!</h1></body></html>
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
