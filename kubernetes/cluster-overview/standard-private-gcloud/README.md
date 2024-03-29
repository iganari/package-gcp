# Create Private Cluster of Standard mode

## キーワード

+ [x] Standard mode
+ [ ] ~Autopilot mode~
+ [ ] ~Public Cluster~
+ [x] Priavte Cluster

## 実際に作ってみる

+ GCP と認証します

```
gcloud auth login --no-launch-browser -q
```

+ 環境変数を入れておきます
  + 適宜、読み替えてください

```
### Env

export _gc_pj_id='Your Google Cloud Project ID'

export _common='pristd'
export _region='asia-northeast1'
export _sub_network_range='10.146.0.0/20'
```

+ API を有効化します

```
gcloud beta services enable container.googleapis.com --project ${_gc_pj_id}
```

+ ネットワークを作成します

```
### VPC 作成
gcloud beta compute networks create ${_common}-network \
  --subnet-mode=custom \
  --project ${_gc_pj_id}

### サブネット作成
gcloud beta compute networks subnets create ${_common}-subnets \
  --network ${_common}-network \
  --region ${_region} \
  --range ${_sub_network_range} \
  --enable-private-ip-google-access \
  --project ${_gc_pj_id}

### 内部通信はすべて許可
gcloud beta compute firewall-rules create ${_common}-allow-internal-all \
  --network ${_common}-network \
  --action ALLOW \
  --rules tcp:0-65535,udp:0-65535,icmp \
  --source-ranges ${_sub_network_range} \
  --target-tags ${_common}-allow-internal-all \
  --project ${_gc_pj_id}
```

+ Cloud NAT を作成します
    + External IP Address と Cloud Router も必要なので作成する

```
### External IP Address
gcloud beta compute addresses create ${_common}-nat-ip \
    --region ${_region} \
    --project ${_gc_pj_id}

### Cloud Router
gcloud beta compute routers create ${_common}-nat-router \
  --network ${_common}-network \
  --region ${_region} \
  --project ${_gc_pj_id}

### Cloud NAT
gcloud beta compute routers nats create ${_common}-nat \
  --router-region ${_region} \
  --router ${_common}-nat-router \
  --nat-all-subnet-ip-ranges \
  --nat-external-ip-pool ${_common}-nat-ip \
  --project ${_gc_pj_id}
```

+ クラスタを作成します
  + Standard mode のコマンド
    + `create`
  + 限定公開クラスタのオプション
    + `--enable-private-nodes`
  + 限定公開クラスタ時の認証済ネットワーク
    + `--master-ipv4-cidr "10.0.0.0/28"`
    + `--enable-master-authorized-networks`
    + `--master-authorized-networks`

```
gcloud beta container clusters create ${_common}-clt \
  --region ${_region} \
  --release-channel "rapid" \
  --enable-private-nodes \
  --enable-ip-alias \
  --master-ipv4-cidr "10.0.0.0/28" \
  --enable-master-authorized-networks \
  --master-authorized-networks 0.0.0.0/0 \
  --network ${_common}-network \
  --subnetwork ${_common}-subnets \
  --cluster-ipv4-cidr "/17" \
  --services-ipv4-cidr "/22" \
  --num-nodes 1 \
  --project ${_gc_pj_id}
```

+ Service Account の作成します

```
gcloud beta iam service-accounts create ${_common}-node-sa \
  --description="Service Account of GKE Cluster's Node" \
  --display-name="${_common}-node-sa" \
  --project ${_gc_pj_id}
```

+ Service Account に role を付与します

```
### Kubernetes Engine Admin を付与
gcloud projects add-iam-policy-binding ${_gc_pj_id} \
  --member="serviceAccount:${_common}-node-sa@${_gc_pj_id}.iam.gserviceaccount.com" \
  --role='roles/container.admin'

### Storage Admin
gcloud projects add-iam-policy-binding ${_gc_pj_id} \
  --member="serviceAccount:${_common}-node-sa@${_gc_pj_id}.iam.gserviceaccount.com" \
  --role='roles/storage.admin'

### Storage Object Admin
gcloud projects add-iam-policy-binding ${_gc_pj_id} \
  --member="serviceAccount:${_common}-node-sa@${_gc_pj_id}.iam.gserviceaccount.com" \
  --role='roles/storage.objectAdmin'
```

+ Node Pool の追加します

```
gcloud beta container node-pools create "${_common}-add-pool-1" \
  --cluster ${_common}-clt \
  --region ${_region} \
  --service-account "${_common}-node-sa@${_gc_pj_id}.iam.gserviceaccount.com" \
  --machine-type "n1-standard-1" \
  --image-type "COS_CONTAINERD" \
  --preemptible \
  --num-nodes 1 \
  --enable-autoscaling \
  --min-nodes 1 \
  --max-nodes 5 \
  --enable-autoupgrade \
  --enable-autorepair \
  --max-surge-upgrade 1 \
  --max-unavailable-upgrade 0 \
  --project ${_gc_pj_id}
```

+ デフォルトで作られた node pool を削除します

```
gcloud beta container node-pools delete default-pool \
  --cluster ${_common}-clt \
  --region ${_region} \
  --project ${_gc_pj_id} \
  -q
```

---> ここまででクラスタの作成が完了

## Pod をデプロイしてみる

+ GKE と認証します

```
gcloud beta container clusters get-credentials ${_common}-clt \
  --region ${_region} \
  --project ${_gc_pj_id}
```

+ GKE 上の Pod を確認します

```
kubectl get pod
```
```
# kubectl get pod
No resources found in default namespace.
```

+ GKE 上に疎通テスト用の pod をデプロイします

```
kubectl run test-pod --image=ubuntu:focal-20210416 --command -- tail -f /dev/null
```

+ 再度、 GKE 上の Pod を確認します

```
kubectl get pod
```
```
### 例

# kubectl get po
NAME       READY   STATUS    RESTARTS   AGE
test-pod   1/1     Running   0          18s
```

+ Pod にログインします

```
kubectl exec -it test-pod /bin/bash
```

+ 必要なパッケージのインストール

```
apt update
apt install -y dnsutils curl iputils-ping
```

+ Pod 内から外部に通信を試してみます

```
# ping -c 5 google.com

PING google.com (142.251.42.174) 56(84) bytes of data.
64 bytes from nrt12s46-in-f14.1e100.net (142.251.42.174): icmp_seq=1 ttl=121 time=2.75 ms
64 bytes from nrt12s46-in-f14.1e100.net (142.251.42.174): icmp_seq=2 ttl=121 time=2.00 ms
64 bytes from nrt12s46-in-f14.1e100.net (142.251.42.174): icmp_seq=3 ttl=121 time=1.83 ms
64 bytes from nrt12s46-in-f14.1e100.net (142.251.42.174): icmp_seq=4 ttl=121 time=1.93 ms
64 bytes from nrt12s46-in-f14.1e100.net (142.251.42.174): icmp_seq=5 ttl=121 time=1.89 ms

--- google.com ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4006ms
rtt min/avg/max/mdev = 1.832/2.080/2.754/0.340 ms
```

```
# dig google.com

; <<>> DiG 9.18.1-1ubuntu1.3-Ubuntu <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 30143
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             7       IN      A       142.251.42.174

;; Query time: 2 msec
;; SERVER: 10.102.128.10#53(10.102.128.10) (UDP)
;; WHEN: Mon Mar 13 02:23:46 UTC 2023
;; MSG SIZE  rcvd: 55
```

```
# curl -I www.google.com

HTTP/1.1 200 OK
Content-Type: text/html; charset=ISO-8859-1
P3P: CP="This is not a P3P policy! See g.co/p3phelp for more info."
Date: Mon, 13 Mar 2023 02:24:18 GMT
Server: gws
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
Transfer-Encoding: chunked
Expires: Mon, 13 Mar 2023 02:24:18 GMT
Cache-Control: private
Set-Cookie: 1P_JAR=2023-03-13-02; expires=Wed, 12-Apr-2023 02:24:18 GMT; path=/; domain=.google.com; Secure
Set-Cookie: AEC=ARSKqsIXPUFS1Pn0bbP4i7b_bhyhI4cak_1Bizty6epP-iNDReiW1qjljjc; expires=Sat, 09-Sep-2023 02:24:18 GMT; path=/; domain=.google.com; Secure; HttpOnly; SameSite=lax
Set-Cookie: NID=511=k1fDdXieR_xON5HfwGVkNPnhwQdfuGa4HgrEjJc2Fe3FCUIfNj38_Bb6y6VnGepmhjc_P_cFh-DvCbtPfW2olkRE6vQSI73Qw89sX9-LMuKFF-GksUeIY2BTMqndjJcKJVXbMBOLauDkObpR2vb5whQAlARN22M_J_ieKIf3ApM; expires=Tue, 12-Sep-2023 02:24:18 GMT; path=/; domain=.google.com; HttpOnly
```

---> GKE 上の Pod が外部のコンテンツを取得出来ていることを確認出来た

+ ログアウト

```
exit
```

---> テスト完了


## リソースの削除

+ Pod の削除をします

```
kubectl delete pod test-pod
```

+ クラスタの削除をします

```
gcloud beta container clusters delete ${_common}-clt \
  --region ${_region} \
  --project ${_gc_pj_id} \
  -q
```

+ Service Account の削除をします

```
gcloud beta iam service-accounts delete ${_common}-node-sa@${_gc_pj_id}.iam.gserviceaccount.com \
  --project ${_gc_pj_id} \
  -q
```

+ Cloud NAT の削除をします

```
gcloud beta compute routers nats delete ${_common}-nat \
  --router-region ${_region} \
  --router ${_common}-nat-router \
  --project ${_gc_pj_id} \
  -q

gcloud beta compute routers delete ${_common}-nat-router \
  --region ${_region} \
  --project ${_gc_pj_id} \
  -q

gcloud beta compute addresses delete ${_common}-nat-ip \
    --region ${_region} \
    --project ${_gc_pj_id} \
  -q
```

+ ネットワークの削除をします

```
gcloud beta compute firewall-rules delete ${_common}-allow-internal-all \
  --project ${_gc_pj_id} \
  -q

gcloud beta compute networks subnets delete ${_common}-subnets \
  --region ${_region} \
  --project ${_gc_pj_id} \
  -q

gcloud beta compute networks delete ${_common}-network \
  --project ${_gc_pj_id} \
  -q
```
