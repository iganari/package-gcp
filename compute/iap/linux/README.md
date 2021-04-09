# IAP to GCE using Linux

## 概要

IAP 越しに パブリック IP アドレスが無い GCE( Linux ) にログインします

```
参考 URL
https://cloud.google.com/iap/docs/using-tcp-forwarding#gcloud_2
```

```
今ページの最終更新日
2021/04/09
```

## 準備

※ IAP をユーザ毎に設定するので、 GCP 上で使用出来るユーザの Email が必要になります

```
### GitLab 用の環境変数

export _gcp_pj_id='Your GCP Project ID'
export _common='iap-linux'
export _region='asia-northeast1'
export _zone='asia-northeast1-c'
export _your_gcp_email='Your GCP Email'
```

+ GCP との認証

```
gcloud auth login -q
```

## ネットワークの作成

+ VPC ネットワークの作成

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
  --range 10.146.0.0/20 \
  --project ${_gcp_pj_id}
```

+ Firewall Rule の作成

```
### 内部通信は全部許可する
gcloud beta compute firewall-rules create ${_common}-allow-internal \
  --network ${_common}-network \
  --source-ranges=10.146.0.0/20 \
  --allow tcp:0-65535,udp:0-65535,icmp \
  --target-tags ${_common}-allow-internal \
  --project ${_gcp_pj_id}

### IAP からの SSH と ICMP を許可する
gcloud beta compute firewall-rules create ${_common}-allow-ssh \
  --network ${_common}-network \
  --source-ranges=35.235.240.0/20 \
  --allow tcp:22,icmp \
  --target-tags ${_common}-allow-ssh \
  --project ${_gcp_pj_id}
```

+ Cloud NAT で使用する IP Address の予約

```
gcloud beta compute addresses create ${_common}-nat-ip \
    --region ${_region} \
    --project ${_gcp_pj_id}
```

+ Cloud NAT で使用する Cloud Router を作成

```
gcloud beta compute routers create ${_common}-router \
  --network ${_common}-network \
  --region ${_region} \
  --project ${_gcp_pj_id}
```

+ Cloud NAT の作成

```
gcloud beta compute routers nats create ${_common}-nat \
  --router-region ${_region} \
  --router ${_common}-router \
  --nat-all-subnet-ip-ranges \
  --nat-external-ip-pool ${_common}-nat-ip \
  --project ${_gcp_pj_id}
```

## IAM

+ IAP を使用するための Role を付与

```
gcloud beta projects add-iam-policy-binding ${_gcp_pj_id} \
    --member=user:${_your_gcp_email} \
    --role=roles/iap.tunnelResourceAccessor
```

## GCE の作成

+ 静的外部 IP アドレスが付いていない VM の作成

```
gcloud beta compute instances create ${_common}-vm \
  --zone ${_zone} \
  --machine-type f1-micro \
  --subnet ${_common}-subnets \
  --no-address \
  --tags=${_common}-allow-internal,${_common}-allow-ssh \
  --image=ubuntu-minimal-2010-groovy-v20210223 \
  --image-project=ubuntu-os-cloud \
  --project ${_gcp_pj_id}
```

+ 作成した VM に IAP 越しに SSH ログインする

```
gcloud beta compute ssh ${_common}-vm --zone ${_zone} --project ${_gcp_pj_id}
```
```
### 例

# gcloud beta compute ssh ${_common}-vm --zone ${_zone} --project ${_gcp_pj_id}
External IP address was not found; defaulting to using IAP tunneling.
Updating project ssh metadata...⠹Updated [https://www.googleapis.com/compute/beta/projects/your_gcp_project_id].
Updating project ssh metadata...done.
Waiting for SSH key to propagate.
Warning: Permanently added 'compute.6486627765331168965' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.10 (GNU/Linux 5.8.0-1023-gcp x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.

0 updates can be installed immediately.
0 of these updates are security updates.


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
```

+ OS の確認

```
# cat /etc/os-release
NAME="Ubuntu"
VERSION="20.10 (Groovy Gorilla)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.10"
VERSION_ID="20.10"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=groovy
UBUNTU_CODENAME=groovy
```
```
# uname -a
Linux iap-linux-vm 5.8.0-1023-gcp #24-Ubuntu SMP Wed Feb 10 01:04:18 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

---> IAP 越しに パブリック IP アドレスが無い GCE( Linux ) に SSH ログインすることが出来ました :)

# まとめ

本来、静的外部 IP アドレスが付いていない VM へは外部からアクセス出来ませんが、IAP 越しに接続することで SSH ログインすることが出来ることが分かりました :raised_hands:

IAP を使用することで GCE へのログインもよりセキュアに実施していきましょう

Have fun! :)


## リソースの削除

+ GCE の削除

```
gcloud beta compute instances delete ${_common}-vm \
  --zone ${_zone} \
  --project ${_gcp_pj_id} -q
```

+ Cloud NAT の削除

```
gcloud beta compute routers nats delete ${_common}-nat \
  --router-region ${_region} \
  --router ${_common}-router \
  --project ${_gcp_pj_id} -q
```

+ Cloud Router の削除

```
gcloud beta compute routers delete ${_common}-router \
  --region ${_region} \
  --project ${_gcp_pj_id} -q
```

+ Cloud NAT 用の外部 IP アドレスを削除

```
gcloud beta compute addresses delete ${_common}-nat-ip \
    --region ${_region} \
    --project ${_gcp_pj_id} -q
```

+ Firewall Rule の削除

```
gcloud beta compute firewall-rules delete ${_common}-allow-internal \
  --project ${_gcp_pj_id} -q

gcloud beta compute firewall-rules delete ${_common}-allow-ssh \
  --project ${_gcp_pj_id} -q
```

+ サブネットの削除

```
gcloud beta compute networks subnets delete ${_common}-subnets \
  --region ${_region} \
  --project ${_gcp_pj_id} -q
```

+ VPC ネットワークの作成

```
gcloud beta compute networks delete ${_common}-network \
  --project ${_gcp_pj_id} -q
```
