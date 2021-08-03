# basic

+ 以下の文字列を用意する

```
BHpYWwA6AWiL8DqnxhkeRLik2F8C37jWUwwUJDYXVsMTRxbcdixvmUYhVievrp35
```
```

export _string='BHpYWwA6AWiL8DqnxhkeRLik2F8C37jWUwwUJDYXVsMTRxbcdixvmUYhVievrp35'
```

+ 文字列を base64 エンコード

```
echo -n "${_string}" | base64
```
```
### 例

$ echo -n "${_string}" | base64
QkhwWVd3QTZBV2lMOERxbnhoa2VSTGlrMkY4QzM3aldVd3dVSkRZWFZzTVRSeGJjZGl4dm1VWWhWaWV2cnAzNQ==
```

+ デコード

```
echo -n "QkhwWVd3QTZBV2lMOERxbnhoa2VSTGlrMkY4QzM3aldVd3dVSkRZWFZzTVRSeGJjZGl4dm1VWWhWaWV2cnAzNQ==" | base64 --decode
```
```
$ echo -n "QkhwWVd3QTZBV2lMOERxbnhoa2VSTGlrMkY4QzM3aldVd3dVSkRZWFZzTVRSeGJjZGl4dm1VWWhWaWV2cnAzNQ==" | base64 --decode
BHpYWwA6AWiL8DqnxhkeRLik2F8C37jWUwwUJDYXVsMTRxbcdixvmUYhVievrp35
```

```
kubectl get pod
```

```
### 例

# kubectl get pod
NAME                            READY   STATUS    RESTARTS   AGE
secret-sample-5c5dd987dc-jztzv  1/1     Running   0          61s
```

```
kubectl exec -it $(kubectl get pod | grep secret-sample | awk '{print $1}') -- env
```
```
### 例

# kubectl exec -it $(kubectl get pod | grep secret-sample | awk '{print $1}') -- env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=secret-sample-5c5dd987dc-jztzv
TERM=xterm
MY_SCT_ENV=BHpYWwA6AWiL8DqnxhkeRLik2F8C37jWUwwUJDYXVsMTRxbcdixvmUYhVievrp35
FRONT_SERVICE_HOST=10.60.12.150
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT_443_TCP=tcp://10.60.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
FRONT_PORT=tcp://10.60.12.150:80
FRONT_PORT_80_TCP_PROTO=tcp
FRONT_PORT_80_TCP_ADDR=10.60.12.150
KUBERNETES_PORT_443_TCP_ADDR=10.60.0.1
FRONT_SERVICE_PORT=80
FRONT_PORT_80_TCP=tcp://10.60.12.150:80
KUBERNETES_SERVICE_HOST=10.60.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_PORT=tcp://10.60.0.1:443
KUBERNETES_PORT_443_TCP_PORT=443
FRONT_PORT_80_TCP_PORT=80
NGINX_VERSION=1.12.1
HOME=/root
```