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
curl -I -L 34.146.173.95
```
```
### Ex.

$ curl -I -L 34.146.173.95
HTTP/1.1 302 Moved Temporarily
Server: nginx/1.21.1
Date: Wed, 18 Aug 2021 01:51:08 GMT
Content-Type: text/html
Content-Length: 145
Connection: keep-alive
Location: https://www.google.com/

HTTP/2 200
content-type: text/html; charset=ISO-8859-1
p3p: CP="This is not a P3P policy! See g.co/p3phelp for more info."
date: Wed, 18 Aug 2021 01:51:08 GMT
server: gws
x-xss-protection: 0
x-frame-options: SAMEORIGIN
expires: Wed, 18 Aug 2021 01:51:08 GMT
cache-control: private
set-cookie: 1P_JAR=2021-08-18-01; expires=Fri, 17-Sep-2021 01:51:08 GMT; path=/; domain=.google.com; Secure
set-cookie: NID=221=zlfkD5Y0Da41Db3SM2ACnydy3ISJgR_pAbsDYPbM_DATwymYeUdZq5A0Pi9j-m53NttFeabtNZ8ozigGKRqMQbhNPht10IKU0FvIHAGcccZK6nYYuqrnME-ohJIXyiRhAiofO2nETZFFbrwCGgyLC0D-c9Opu5E5ox5RTQpcg2o; expires=Thu, 17-Feb-2022 01:51:08 GMT; path=/; domain=.google.com; HttpOnly
```

## 付録

+ オリジナルの設定ファイル
  + [/etc/nginx/nginx.conf](./nginx.conf)
  + [/etc/nginx/conf.d/](./conf.d)

## リソース削除

+ リソースを纏めて削除する

```
kubectl delete -f main_after.yaml
```

