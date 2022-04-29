# VM Instance で Windows を作る

## VM Instance 作成

+ GCP と認証する

```
gcloud auth application-default login --no-launch-browser -q
```

```
### Env

export _common='pkg-gcp'
export _gcp_pj_id='Your GCP Project ID'
export _region='asia-northeast1'
export _sub_network_range='172.16.0.0/12'
export _my_ip='Your Home IP'
export _bastion_vm_ip='xxx.xxx.xxx.xxx'
```

+ API を enable

```
gcloud beta services enable compute.googleapis.com --project ${_gcp_pj_id}
```

+ VPC Network の作成

```
gcloud beta compute networks create ${_common}-network \
  --subnet-mode=custom \
  --project ${_gcp_pj_id}
```

+ サブネットの作成

```
gcloud beta compute networks subnets create ${_common}-subnets \
  --network ${_common}-network \
  --region ${_region} \
  --enable-private-ip-google-access \
  --range ${_sub_network_range} \
  --project ${_gcp_pj_id}
```

+ Firewall

```
### 内部通信
gcloud beta compute firewall-rules create ${_common}-allow-internal-all \
  --network ${_common}-network \
  --action ALLOW \
  --rules tcp:0-65535,udp:0-65535,icmp \
  --source-ranges ${_sub_network_range} \
  --target-tags ${_common}-allow-internal-all \
  --project ${_gcp_pj_id}

### RDP
gcloud beta compute firewall-rules create ${_common}-allow-rdp \
  --network ${_common}-network \
  --action ALLOW \
  --rules tcp:3389,icmp \
  --source-ranges ${_my_ip},${_bastion_vm_ip} \
  --target-tags ${_common}-allow-rdp \
  --project ${_gcp_pj_id}
```

+ IP Address の予約

```
gcloud beta compute addresses create ${_common}-ip \
  --region ${_region} \
  --project ${_gcp_pj_id}
```

+ VM Instance の作成

```
gcloud beta compute instances create ${_common}-vm \
  --zone ${_region}-b \
  --machine-type e2-small \
  --subnet ${_common}-subnets \
  --address ${_common}-ip \
  --tags=${_common}-allow-internal-all,${_common}-allow-rdp \
  --image windows-server-2019-dc-v20211216 \
  --image-project windows-cloud \
  --boot-disk-size 50GB \
  --project ${_gcp_pj_id}
```

## Windows のログインパスワードを作成

+ gcloud コマンドにて作成
  + https://cloud.google.com/compute/docs/instances/windows/generating-credentials#gcloud

```
gcloud beta compute reset-windows-password ${_common}-vm \
  --zone ${_region}-b \
  --user iganari \
  --project ${_gcp_pj_id} \
  -q
```
```
### 例

$ gcloud beta compute reset-windows-password ${_common}-vm \
  --zone ${_region}-b \
  --user iganari \
  --project ${_gcp_pj_id} \
  -q

Resetting and retrieving password for [iganari] on [your_gce_instance_name]
Updated [https://www.googleapis.com/compute/beta/projects/your_gcp_pj_id/zones/asia-northeast1-b/instances/your_gce_instance_name].
ip_address: your_external_ip_address
password:   your_rdp_password
username:   iganari
```

## RDP でログイン

やること | スクリーンショット
:- | :-
RDP 接続 | ![](./img/rdp-login-01.png)
ユーザ、パスワード | ![](./img/rdp-login-02.png)
ログイン成功 | ![](./img/rdp-login-03.png)
Server Manager を確認 | ![](./img/rdp-login-04.png)
IE Enhanced Security Configuration で off にする| ![](./img/rdp-login-05.png)
Server Manager を確認 | ![](./img/rdp-login-06.png)

