# IAP for TCP forwarding to Windows Server VM Instance

## 概要

外部 IP アドレスが無い Windows Server VM Instance に IAP 越しに SSH ログインします

![](./_img/main.png)

+ 参考 URL
  + [Setting up IAP for Compute Engine](https://cloud.google.com/iap/docs/tutorial-gce)
  + [Enabling IAP for Compute Engine](https://cloud.google.com/iap/docs/enabling-compute-howto)
  + [Using IAP for TCP forwarding](https://cloud.google.com/iap/docs/using-tcp-forwarding)

+ Google Cloud に認証を通す

```
gcloud auth login --no-launch-browser -q
```

```
### Env

export _gc_pj_id='Your Google Cloud Project ID'

export _common='pkg-gcp'
export _region='asia-northeast1'
export _zone=`echo ${_region}-b`
export _sub_network_range='10.146.0.0/20'
```

+ API を有効化

```
gcloud beta services enable compute.googleapis.com --project ${_gc_pj_id}
```

## 1. Service Account の作成

+ GCE Instance 用の Service Account の作成

```
gcloud beta iam service-accounts create ${_common}-sa \
  --description="${_common}-sa for Package GCP" \
  --display-name="${_common}-sa" \
  --project ${_gc_pj_id}
```

## 2. ネットワークの作成

+ VPC Network の作成

```
gcloud beta compute networks create ${_common}-network \
  --subnet-mode=custom \
  --project ${_gc_pj_id}
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
  + IAP のレンジなど ---> [package-gcp/networking/firewalls](../../../networking/firewalls)

```
### 内部通信用
gcloud beta compute firewall-rules create ${_common}-allow-internal-all \
  --network ${_common}-network \
  --action ALLOW \
  --rules tcp:0-65535,udp:0-65535,icmp \
  --source-ranges ${_sub_network_range} \
  --project ${_gc_pj_id}


### IAP からの RDP と ICMP を許可する (Windows Serverの場合)
gcloud beta compute firewall-rules create ${_common}-allow-iap-rdp \
  --network ${_common}-network \
  --direction=INGRESS \
  --action ALLOW \
  --rules tcp:3389,icmp \
  --source-ranges=35.235.240.0/20 \
  --target-service-accounts ${_common}-sa@${_gc_pj_id}.iam.gserviceaccount.com \
  --priority=1010 \
  --project ${_gc_pj_id}
```

+ Cloud NAT で使用する外部 IP Address の予約

```
gcloud beta compute addresses create ${_common}-nat-ip \
  --region ${_region} \
  --project ${_gc_pj_id}
```

+ Cloud NAT で使用する Cloud Router を作成

```
gcloud beta compute routers create ${_common}-nat-router \
  --network ${_common}-network \
  --region ${_region} \
  --project ${_gc_pj_id}
```

+ Cloud NAT の作成

```
gcloud beta compute routers nats create ${_common}-nat \
  --router-region ${_region} \
  --router ${_common}-nat-router \
  --nat-all-subnet-ip-ranges \
  --nat-external-ip-pool ${_common}-nat-ip \
  --project ${_gc_pj_id}
```

## 3. 外部 IP アドレスがついた VM instance の作成

+ GCE Instance のパブリックイメージの検索
  + https://cloud.google.com/compute/docs/images

```
### 例: Ubuntu のイメージを探すコマンド
gcloud beta compute images list --filter="name~'^windows-server-.*?'" --project ${_gc_pj_id}
```

+ 環境変数を設定

```
export _boot_project='windows-cloud'
export _boot_image='windows-server-2022-dc-v20231213'
export _boot_size='50'

export _machine_type='e2-small'
export _vm_provisioning_model='STANDARD'   ### STANDARD/SPOT  <--- Spot VM
export _maintenance_policy='MIGRATE'       ### MIGRATE/TERMINATE
```

+ VM Instance の作成

```
gcloud beta compute instances create ${_common}-vm \
  --zone ${_zone} \
  --machine-type ${_machine_type} \
  --network-interface=no-address,stack-type=IPV4_ONLY,subnet=${_common}-subnets \
  --maintenance-policy ${_maintenance_policy} \
  --provisioning-model ${_vm_provisioning_model} \
  --service-account=${_common}-sa@${_gc_pj_id}.iam.gserviceaccount.com \
  --scopes=https://www.googleapis.com/auth/cloud-platform \
  --create-disk=auto-delete=yes,boot=yes,image=projects/${_boot_project}/global/images/${_boot_image},mode=rw,size=${_boot_size},type=projects/${_gc_pj_id}/zones/${_zone}/diskTypes/pd-standard \
  --shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring \
  --project ${_gc_pj_id}
```

## 4. VM instance に SSH ログインする

作成した VM Instance に IAP 越しにログインします

### 4-1. RDP ログインする場合 〜Tunneling RDP connections〜

+ Windows Server の ID とパスワードを作る

```
gcloud beta compute reset-windows-password ${_common}-vm \
  --zone ${_zone} \
  --user=iganari \
  --project ${_gc_pj_id}
```

<details>
<summary>実行例</summary>

```
### 例
$ gcloud beta compute reset-windows-password ${_common}-win --zone ${_zone} --user=iganari --project ${_gcp_pj_id}

password: ********    # <----- 本来は表示されます
username: iganari
```

</details>

+ gcloud コマンドで、ローカル PC と VM Instance 間で TCP tunnel を作る
  + 例) GCE Instance の 3389 ポートと localhost の 13389 を繋ぐ

```
gcloud beta compute start-iap-tunnel ${_common}-vm 3389 \
  --local-host-port=localhost:13389 \
  --zone ${_zone} \
  --project ${_gc_pj_id}
```

<details>
<summary>実行例</summary>

```
### 例

% gcloud beta compute start-iap-tunnel ${_common}-vm 3389 \
  --local-host-port=localhost:13389 \
  --zone ${_zone} \
  --project ${_gc_pj_id}

Testing if tunnel connection works.
Listening on port [13389].


```

+ terminal はこのままで Microsoft Remote Desktop から RDP 接続をする

![](./img/win-01.png)

![](./img/win-02.png)

![](./img/win-03.png)

---> IAP 越しに外部 IP アドレスが無い VM Instance (Windows Server) に RDP ログインすることが出来ました :)

</details>

### 4-2. Windows Server の GCE インスタンスに RDP ログインする場合 〜IAP Desktop〜

<details>
<summary>Details</summary>

[IAP Desktop の Connect to Windows VMs with Remote Desktop](https://github.com/GoogleCloudPlatform/iap-desktop/#connect-to-windows-vms-with-remote-desktop) を使う


![](https://raw.githubusercontent.com/GoogleCloudPlatform/iap-desktop/master/doc/images/RemoteDesktop_350.gif)

</details>


## まとめ

本来、外部 IP アドレスが付いていない GCE へは外部からアクセス出来ませんが、IAP 越しに接続することで SSH ログインおよび RDP ログインすることが出来ることが分かりました :raised_hands:

IAP を使用することで GCE へのログインもよりセキュアに実施していきましょう

Have fun! :)

## 99. クリーンアップ

<details>
<summary>99-1. VM Instance の削除</summary>

```
gcloud beta compute instances delete ${_common}-vm \
  --zone ${_zone} \
  --project ${_gc_pj_id} \
  --quiet
```

</details>

<details>
<summary>99-2. Cloud NAT の削除</summary>

```
gcloud beta compute routers nats delete ${_common}-nat \
  --router-region ${_region} \
  --router ${_common}-nat-router \
  --project ${_gc_pj_id} \
  --quiet
```

</details>

<details>
<summary>99-3. Cloud Router の削除</summary>

```
gcloud beta compute routers delete ${_common}-nat-router \
  --region ${_region} \
  --project ${_gc_pj_id} \
  --quiet
```

</details>

<details>
<summary>99-4. Cloud NAT 用の外部 IP アドレスを削除</summary>

```
gcloud beta compute addresses delete ${_common}-nat-ip \
  --region ${_region} \
  --project ${_gc_pj_id} \
  --quiet
```

</details>

<details>
<summary>99-5. Firewall Rule の削除</summary>

```
### 内部通信用
gcloud beta compute firewall-rules delete ${_common}-allow-internal-all \
  --project ${_gc_pj_id} \
  --quiet

### SSH 用
gcloud beta compute firewall-rules delete ${_common}-allow-iap-rdp \
  --project ${_gc_pj_id} \
  --quiet
```

</details>

<details>
<summary>99-6. サブネットの削除</summary>

```
gcloud beta compute networks subnets delete ${_common}-subnets \
  --region ${_region} \
  --project ${_gc_pj_id} \
  --quiet
```

</details>

<details>
<summary>99-7. VPC Network の削除</summary>

```
gcloud beta compute networks delete ${_common}-network \
  --project ${_gc_pj_id} \
  --quiet
```

</details>

<details>
<summary>99-8. Service Account の削除</summary>

```
gcloud beta iam service-accounts delete ${_common}-sa@${_gc_pj_id}.iam.gserviceaccount.com \
  --project ${_gc_pj_id} \
  --quiet
```

</details>
