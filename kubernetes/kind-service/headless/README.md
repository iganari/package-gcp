# kind: Service/Headless

## 概要


## 実際に触ってみる



## 変数を設定

+ 以下を環境変数として設定しておきます

```
### Env

export _common='srvhl'
export _gcp_pj_id='Your GCP Project ID'ca-igarashi-test-softbank
export _region='asia-northeast1'
export _sub_network_range='10.146.0.0/20'
```

## GKE クラスタの作成

Standard mode の一般公開クラスタを作成します

作成方法はこの Repository の [Create Public Cluster of Standard mode](../../about-cluster/standard-public-gcloud/) を参考にしてください

## manifestをデプロイ

+ GKE と認証します

```
gcloud beta container clusters get-credentials ${_common}-clt \
  --region ${_region} \
  --project ${_gcp_pj_id}
```

+ manifestをしようして、リソースをデプロイします
  + 内容は [main.yaml](./main.yaml) を参照してください

```
kubectl apply -f nginx.yaml
```


```
kubectl get service
```
```
# kubectl get service
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
nginx-svc    ClusterIP   None           <none>        80/TCP    16m
```
```
kubectl get statefulset
```
```
# kubectl get statefulset
NAME                READY   AGE
nginx-statefulset   3/3     15m
```
```
kubectl get pod
```
```
# kubectl get pod
NAME                  READY   STATUS    RESTARTS   AGE
nginx-statefulset-0   1/1     Running   0          4m8s
nginx-statefulset-1   1/1     Running   0          6m21s
nginx-statefulset-2   1/1     Running   0          5m29s
```

## 検証1: 名前解決が出来るか

### Service の 名前解決の命名規則

```
my-svc.my-namespace.svc.cluster.local = {Service Name}.{Name Space name}.svc.cluster.local
```

[ServiceとPodに対するDNS](https://kubernetes.io/ja/docs/concepts/services-networking/dns-pod-service/)

+ Service の name `nginx-svc` で名前解決をしてみる
  + :fire: 使用する pod は後ほど変更する
  + headless -> https://kubernetes.io/ja/docs/concepts/services-networking/dns-pod-service/#srvレコード

```
kubectl run --rm -i test-pod --image=tutum/dnsutils --restart=Never -- dig nginx-svc.default.svc.cluster.local
```

```
# kubectl run --rm -i test-pod --image=tutum/dnsutils --restart=Never -- dig nginx-svc.default.svc.cluster.local

; <<>> DiG 9.9.5-3ubuntu0.2-Ubuntu <<>> nginx-svc.default.svc.cluster.local
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 3967
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;nginx-svc.default.svc.cluster.local. IN        A

;; ANSWER SECTION:
nginx-svc.default.svc.cluster.local. 30 IN A    10.152.6.16
nginx-svc.default.svc.cluster.local. 30 IN A    10.152.3.10
nginx-svc.default.svc.cluster.local. 30 IN A    10.152.4.25

;; Query time: 2 msec
;; SERVER: 10.152.128.10#53(10.152.128.10)
;; WHEN: Thu Jul 15 08:29:08 UTC 2021
;; MSG SIZE  rcvd: 101

pod "test-pod" deleted
```

### Headless Service に紐づけている StatefulSet のそれぞれの pod の名前解決の命名規則

---> 詳しくは公式
---> 今はなまえかいけつのみやりたい

```
{Pod name}.{Service Name}.{Name Space name}.svc.cluster.local
```

+ [再掲] pod の確認

```
# kubectl get pod
NAME                  READY   STATUS    RESTARTS   AGE
nginx-statefulset-0   1/1     Running   0          4m8s
nginx-statefulset-1   1/1     Running   0          6m21s
nginx-statefulset-2   1/1     Running   0          5m29s
```

+ pod の名前解決
  + `nginx-statefulset-1` の場合は `nginx-statefulset-1.nginx-svc.default.svc.cluster.local`

```
### 実行すべきコマンド

kubectl run --rm -i test-pod --image=tutum/dnsutils --restart=Never -- dig nginx-statefulset-0.nginx-svc.default.svc.cluster.local
kubectl run --rm -i test-pod --image=tutum/dnsutils --restart=Never -- dig nginx-statefulset-1.nginx-svc.default.svc.cluster.local
kubectl run --rm -i test-pod --image=tutum/dnsutils --restart=Never -- dig nginx-statefulset-2.nginx-svc.default.svc.cluster.local
```
```
### nginx-statefulset-0 の場合

# kubectl run --rm -i test-pod --image=tutum/dnsutils --restart=Never -- dig nginx-statefulset-0.nginx-svc.default.svc.cluster.local

; <<>> DiG 9.9.5-3ubuntu0.2-Ubuntu <<>> nginx-statefulset-0.nginx-svc.default.svc.cluster.local
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 47505
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;nginx-statefulset-0.nginx-svc.default.svc.cluster.local. IN A

;; ANSWER SECTION:
nginx-statefulset-0.nginx-svc.default.svc.cluster.local. 30 IN A 10.152.3.10

;; Query time: 3 msec
;; SERVER: 10.152.128.10#53(10.152.128.10)
;; WHEN: Thu Jul 15 08:38:33 UTC 2021
;; MSG SIZE  rcvd: 89

pod "test-pod" deleted
```
```
### nginx-statefulset-1 の場合

# kubectl run --rm -i test-pod --image=tutum/dnsutils --restart=Never -- dig nginx-statefulset-1.nginx-svc.default.svc.cluster.local

; <<>> DiG 9.9.5-3ubuntu0.2-Ubuntu <<>> nginx-statefulset-1.nginx-svc.default.svc.cluster.local
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 27345
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;nginx-statefulset-1.nginx-svc.default.svc.cluster.local. IN A

;; ANSWER SECTION:
nginx-statefulset-1.nginx-svc.default.svc.cluster.local. 30 IN A 10.152.4.25

;; Query time: 2 msec
;; SERVER: 10.152.128.10#53(10.152.128.10)
;; WHEN: Thu Jul 15 08:37:32 UTC 2021
;; MSG SIZE  rcvd: 89

pod "test-pod" deleted
```
```
### nginx-statefulset-2 の場合

# kubectl run --rm -i test-pod --image=tutum/dnsutils --restart=Never -- dig nginx-statefulset-2.nginx-svc.default.svc.cluster.local

; <<>> DiG 9.9.5-3ubuntu0.2-Ubuntu <<>> nginx-statefulset-2.nginx-svc.default.svc.cluster.local
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 43966
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;nginx-statefulset-2.nginx-svc.default.svc.cluster.local. IN A

;; ANSWER SECTION:
nginx-statefulset-2.nginx-svc.default.svc.cluster.local. 30 IN A 10.152.6.16

;; Query time: 3 msec
;; SERVER: 10.152.128.10#53(10.152.128.10)
;; WHEN: Thu Jul 15 08:39:38 UTC 2021
;; MSG SIZE  rcvd: 89

pod "test-pod" deleted
```

---> StatefulSet の Replica で作った Pod それぞれに名前解決出来ることが分かりました :)

## 検証2: Pod の再起動により名前解決の向き先が変わるか

検証1 より以下のことが分かっています

```
nginx-statefulset-0.nginx-svc.default.svc.cluster.local. 30 IN A 10.152.3.10
nginx-statefulset-1.nginx-svc.default.svc.cluster.local. 30 IN A 10.152.4.25
nginx-statefulset-2.nginx-svc.default.svc.cluster.local. 30 IN A 10.152.6.16
```

+ Pod を再起動してみます

```
kubectl rollout restart statefulset nginx-statefulset
```

+ Pod が生まれ変わるまで待ちましょう

```
watch -n1 kubectl get po
```
```
### 例

# kubectl get po
NAME                  READY   STATUS    RESTARTS   AGE
nginx-statefulset-0   1/1     Running   0          27s
nginx-statefulset-1   1/1     Running   0          44s
nginx-statefulset-2   1/1     Running   0          60s
```

+ 再度、pod の名前解決


```
### nginx-statefulset-0 の場合

# kubectl run --rm -i test-pod --image=tutum/dnsutils --restart=Never -- dig nginx-statefulset-0.nginx-svc.default.svc.cluster.local

; <<>> DiG 9.9.5-3ubuntu0.2-Ubuntu <<>> nginx-statefulset-0.nginx-svc.default.svc.cluster.local
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 3510
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;nginx-statefulset-0.nginx-svc.default.svc.cluster.local. IN A

;; ANSWER SECTION:
nginx-statefulset-0.nginx-svc.default.svc.cluster.local. 30 IN A 10.152.3.11

;; Query time: 3 msec
;; SERVER: 10.152.128.10#53(10.152.128.10)
;; WHEN: Thu Jul 15 08:47:50 UTC 2021
;; MSG SIZE  rcvd: 89

pod "test-pod" deleted
```
```
### nginx-statefulset-1 の場合

# kubectl run --rm -i test-pod --image=tutum/dnsutils --restart=Never -- dig nginx-statefulset-1.nginx-svc.default.svc.cluster.local

; <<>> DiG 9.9.5-3ubuntu0.2-Ubuntu <<>> nginx-statefulset-1.nginx-svc.default.svc.cluster.local
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 16609
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;nginx-statefulset-1.nginx-svc.default.svc.cluster.local. IN A

;; ANSWER SECTION:
nginx-statefulset-1.nginx-svc.default.svc.cluster.local. 30 IN A 10.152.4.40

;; Query time: 2 msec
;; SERVER: 10.152.128.10#53(10.152.128.10)
;; WHEN: Thu Jul 15 08:49:29 UTC 2021
;; MSG SIZE  rcvd: 89

pod "test-pod" deleted
```
```
### nginx-statefulset-2 の場合

# kubectl run --rm -i test-pod --image=tutum/dnsutils --restart=Never -- dig nginx-statefulset-2.nginx-svc.default.svc.cluster.local

; <<>> DiG 9.9.5-3ubuntu0.2-Ubuntu <<>> nginx-statefulset-2.nginx-svc.default.svc.cluster.local
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 38732
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;nginx-statefulset-2.nginx-svc.default.svc.cluster.local. IN A

;; ANSWER SECTION:
nginx-statefulset-2.nginx-svc.default.svc.cluster.local. 30 IN A 10.152.6.24

;; Query time: 3 msec
;; SERVER: 10.152.128.10#53(10.152.128.10)
;; WHEN: Thu Jul 15 08:50:02 UTC 2021
;; MSG SIZE  rcvd: 89

pod "test-pod" deleted
```

+ 上記より以下のことが分かりました



```
### Pod の再起動前
nginx-statefulset-0.nginx-svc.default.svc.cluster.local. 30 IN A 10.152.3.10
nginx-statefulset-1.nginx-svc.default.svc.cluster.local. 30 IN A 10.152.4.25
nginx-statefulset-2.nginx-svc.default.svc.cluster.local. 30 IN A 10.152.6.16


### Pod の再起動後
nginx-statefulset-0.nginx-svc.default.svc.cluster.local. 30 IN A 10.152.3.11
nginx-statefulset-1.nginx-svc.default.svc.cluster.local. 30 IN A 10.152.4.40
nginx-statefulset-2.nginx-svc.default.svc.cluster.local. 30 IN A 10.152.6.24
```

---> Pod の再起動により IP アドレスは代わっていますが、名前解決は出来ていることが確認できました :)

## 検証3: Pod の再起動により名前解決の向き先の Pod が入れ替わっていないか

+ それぞれの Pod にファイルを置いてみる

```
for i in $(kubectl get pod | awk 'NR>1 {print $1}') ; do echo "Hello World!! :) in $i" > hello.html ; kubectl cp hello.html $i:/usr/share/nginx/html/ ; done
```

+ 確認

```
### nginx-statefulset-0 の場合

# kubectl run --rm -i test-pod --image=centos:6 --restart=Never -- curl nginx-statefulset-0.nginx-svc.default.svc.cluster.local/hello.html
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0    40    0    40    0     0   6576      0 --:--:-- --:--:-- --:--:-- 40000
Hello World!! :) in nginx-statefulset-0
pod "test-pod" deleted
```
```
### nginx-statefulset-1 の場合

# kubectl run --rm -i test-pod --image=centos:6 --restart=Never -- curl nginx-statefulset-1.nginx-svc.default.svc.cluster.local/hello.html
If you don't see a command prompt, try pressing enter.
Error attaching, falling back to logs: unable to upgrade connection: container test-pod not found in pod test-pod_default
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0    40    0    40    0     0   7389      0 --:--:-- --:--:-- --:--:--     0
Hello World!! :) in nginx-statefulset-1
pod "test-pod" deleted
```
```
### nginx-statefulset-2 の場合

# kubectl run --rm -i test-pod --imag
e=centos:6 --restart=Never -- curl nginx-statefulset-2.nginx-svc.default.svc.cluster.local/hello.html
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0    40    0    40    0     0   4815      0 --:--:-- --:--:-- --:--:-- 40000
Hello World!! :) in nginx-statefulset-2
pod "test-pod" deleted
```

+ Pod の再起動をします

```
kubectl rollout restart statefulset nginx-statefulset
```

+ Pod が生まれ変わるのを待ちます

```
kubectl get pod
```

+ 再度 curl で確認をします


```
### nginx-statefulset-0 の場合

# kubectl run --rm -i test-pod --imag
e=centos:6 --restart=Never -- curl nginx-statefulset-0.nginx-svc.default.svc.cluster.local/hello.html
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0    40    0    40    0     0   4308      0 --:--:-- --:--:-- --:--:-- 20000
Hello World!! :) in nginx-statefulset-0
pod "test-pod" deleted
```
```
### nginx-statefulset-1 の場合

# kubectl run --rm -i test-pod --imag
e=centos:6 --restart=Never -- curl nginx-statefulset-1.nginx-svc.default.svc.cluster.local/hello.html
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0    40    0    40    0     0   2181      0 --:--:-- --:--:-- --:--:--  3636
Hello World!! :) in nginx-statefulset-1
pod "test-pod" deleted
```
```
### nginx-statefulset-2 の場合

# kubectl run --rm -i test-pod --imag
e=centos:6 --restart=Never -- curl nginx-statefulset-2.nginx-svc.default.svc.cluster.local/hello.html
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0    40    0    40    0     0   1009      0 --:--:-- --:--:-- --:--:--  1250
Hello World!! :) in nginx-statefulset-2
pod "test-pod" deleted
```

---> (出力は代わっていませんが、) Pod の再起動により、名前解決の向き先の Pod は代わっていない(コンテナは代わっている)ことが分かりました :)


## MySQL で試してみる

WIP

## リソースの削除

```
kubectl delete -f nginx.yaml
```

+ クラスタなどの削除

[Create Public Cluster of Standard mode | リソースの削除](../../about-cluster/standard-public-gcloud/README.md#リソースの削除)

## まとめ

WIP
