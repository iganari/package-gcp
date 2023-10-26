# 外部 IP アドレスがついた VM instance

![](./01.png)

## 実際に構築する

+ Google Cloud に認証を通す

```
gcloud auth login --no-launch-browser -q
```

```
### Env

export _gc_pj_id='Your GCP Project ID'

export _common='external-ip'
export _region='asia-northeast1'
export _zone='asia-northeast1-b'
export _sub_network_range='172.16.0.0/12'

export _my_ip='Your Home IP Address'
export _other_ip='Your other IP Address'
```

+ API を enable 化します

```
gcloud beta services enable compute.googleapis.com --project ${_gc_pj_id}
```

## Service Account の作成

+ GCE Instance 用の SA の作成

```
gcloud beta iam service-accounts create ${_common}-sa-gce \
  --description="for Package GCP" \
  --display-name="${_common}-sa-gce" \
  --project ${_gc_pj_id}
```

## ネットワークの作成

+ VPC Network の作成

```
gcloud beta compute networks create ${_common}-network \
  --subnet-mode=custom \
  --project ${_gcp_pj_id}
```

+ サブネットの作成
  + `限定公開の Google アクセス` を On にしておく

```
gcloud beta compute networks subnets create ${_common}-subnets \
  --network ${_common}-network \
  --region ${_region} \
  --range ${_sub_network_range} \
  --enable-private-ip-google-access \
  --project ${_gc_pj_id}
```

+ Firewall Rule の作成

```
### 内部通信
gcloud beta compute firewall-rules create ${_common}-allow-internal-all \
  --network ${_common}-network \
  --action ALLOW \
  --rules tcp:0-65535,udp:0-65535,icmp \
  --source-ranges ${_sub_network_range} \
  --project ${_gc_pj_id}

### SSH
gcloud beta compute firewall-rules create ${_common}-allow-ssh \
  --network ${_common}-network \
  --action ALLOW \
  --rules tcp:22,icmp \
  --source-ranges ${_my_ip},${_other_ip} \
  --source-service-accounts ${_common}-sa-gce@${_gc_pj_id}.iam.gserviceaccount.com \
  --project ${_gc_pj_id}
```

+ IP Address の予約

```
gcloud beta compute addresses create ${_common}-ip \
  --region ${_region} \
  --project ${_gc_pj_id}
```

## GCE の作成

+ GCE Instance のパブリックイメージの検索
  + https://cloud.google.com/compute/docs/images

```
gcloud beta compute images list --filter="name~'^ubuntu-minimal-.*?'" --project ${_gc_pj_id}
```

+ GCE Instance の作成

```
export _os_project='ubuntu-os-cloud'
export _os_image='ubuntu-minimal-2204-jammy-v20230112a'
```
```
gcloud beta compute instances create ${_common}-vm \
  --zone ${_zone} \
  --machine-type e2-small \
  --subnet ${_common}-subnets \
  --address ${_common}-ip \
  --tags=${_common}-allow-internal-all,${_common}-allow-ssh \
  --image-project ${_os_project} \
  --image ${_os_image} \
  --boot-disk-size 30GB \
  --project ${_gcp_pj_id}
```

## ログイン

```
gcloud auth list --filter=status:ACTIVE --format="value(account)"

export _account=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" | awk -F\@ '{print $1}')
echo ${_account}
```

```
gcloud beta compute ssh ${_account}@${_common}-vm --zone ${_zone} --project ${_gc_pj_id}
```

---> これでログイン出来るはずです :)
