# 外部 IP アドレスがついた VM instance

![](./01.png)

## 0. 準備

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
export _sub_network_range='10.0.0.0/16'

export _my_ip='Your Home IP Address'
export _other_ip='Your other IP Address'
```

- API を有効化

```
gcloud beta services enable compute.googleapis.com --project ${_gc_pj_id}
```

## 1. Service Account の作成

- GCE Instance 用の Service Account の作成

```
gcloud beta iam service-accounts create sa-gce-${_common} \
  --description="[GCE] ${_common} 用の Service Account" \
  --display-name="sa-gce-${_common}" \
  --project ${_gc_pj_id}
```

- Servcie Account に Role を付与

```
### Monitoring Metric Writer
gcloud beta projects add-iam-policy-binding ${_gc_pj_id} \
  --member="serviceAccount:sa-gce-${_common}@${_gc_pj_id}.iam.gserviceaccount.com" \
  --role="roles/monitoring.metricWriter" \
  --condition None


### Logs Writer
gcloud beta projects add-iam-policy-binding ${_gc_pj_id} \
  --member="serviceAccount:sa-gce-${_common}@${_gc_pj_id}.iam.gserviceaccount.com" \
  --role="roles/logging.logWriter" \
  --condition None
```

## 2. ネットワークの作成

- VPC Network の作成

```
gcloud beta compute networks create ${_common} \
  --subnet-mode=custom \
  --project ${_gc_pj_id}
```

- サブネットの作成
  - `限定公開の Google アクセス` を On にしておく

```
gcloud beta compute networks subnets create ${_common} \
  --network ${_common} \
  --region ${_region} \
  --range ${_sub_network_range} \
  --enable-private-ip-google-access \
  --project ${_gc_pj_id}
```

- Firewall Rule の作成
  - [VPC firewall rules](../../../net-security/firewall-manager/firewall-policies/)

```
### SSH 用
gcloud beta compute firewall-rules create ${_common}-allow-ingress-ssh \
  --network ${_common} \
  --action ALLOW \
  --rules tcp:22,icmp \
  --source-ranges ${_my_ip},${_other_ip} \
  --target-service-accounts sa-gce-${_common}@${_gc_pj_id}.iam.gserviceaccount.com \
  --project ${_gc_pj_id}


### IAP 用
gcloud beta compute firewall-rules create ${_common}-allow-ingress-iap \
  --network ${_common} \
  --action ALLOW \
  --rules tcp:22 \
  --source-ranges 35.235.240.0/20 \
  --target-service-accounts sa-gce-${_common}@${_gc_pj_id}.iam.gserviceaccount.com \
  --project ${_gc_pj_id}
```

- 外部 IP Address の予約

```
gcloud beta compute addresses create gce-${_common} \
  --region ${_region} \
  --project ${_gc_pj_id}
```

## 3. 外部 IP アドレスがついた VM instance の作成

- GCE Instance のパブリックイメージの検索
  - https://cloud.google.com/compute/docs/images

```
gcloud beta compute images list --format="table(NAME,PROJECT,FAMILY)"  --filter="(name:ubuntu-minimal-* NOT family:arm64)" --project ${_gc_pj_id}
```
```
### 例: Ubuntu のイメージを探すコマンド
$ gcloud beta compute images list --format="table(NAME,PROJECT,FAMILY)"  --filter="(name:ubuntu-minimal-* NOT family:arm64)" --project ${_gc_pj_id}
NAME                                       PROJECT          FAMILY
ubuntu-minimal-2004-focal-v20240802a       ubuntu-os-cloud  ubuntu-minimal-2004-lts
ubuntu-minimal-2204-jammy-v20240802        ubuntu-os-cloud  ubuntu-minimal-2204-lts
ubuntu-minimal-2404-noble-amd64-v20240801  ubuntu-os-cloud  ubuntu-minimal-2404-lts-amd64
```

- 環境変数を設定

```
export _boot_project='ubuntu-os-cloud'
export _boot_image='ubuntu-minimal-2404-noble-amd64-v20240801'
export _boot_size='30'

export _machine_type='e2-small'
export _vm_provisioning_model='STANDARD'   ### STANDARD/SPOT  <--- Spot VM
export _maintenance_policy='MIGRATE'       ### MIGRATE/TERMINATE
```

- GCE Instance の作成

```
gcloud beta compute instances create ${_common} \
  --zone ${_zone} \
  --machine-type ${_machine_type} \
  --network-interface=address=gce-${_common},stack-type=IPV4_ONLY,subnet=${_common} \
  --maintenance-policy ${_maintenance_policy} \
  --provisioning-model ${_vm_provisioning_model} \
  --service-account=sa-gce-${_common}@${_gc_pj_id}.iam.gserviceaccount.com \
  --scopes=https://www.googleapis.com/auth/cloud-platform \
  --create-disk=auto-delete=yes,boot=yes,image=projects/${_boot_project}/global/images/${_boot_image},mode=rw,size=${_boot_size},type=projects/${_gc_pj_id}/zones/${_zone}/diskTypes/pd-standard \
  --shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring \
  --project ${_gc_pj_id}
```

## 4. GCE instance に SSH ログインする

- Google Account 名を取得

```
gcloud auth list --filter=status:ACTIVE --format="value(account)"

export _account=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" | awk -F\@ '{print $1}')
echo ${_account}
```

- GCE instance に SSH ログインする

```
gcloud beta compute ssh ${_account}@${_common} \
  --zone ${_zone} \
  --project ${_gc_pj_id}

# もしくは

gcloud beta compute ssh ${_account}@${_common} \
  --zone ${_zone} \
  --tunnel-through-iap \
  --project ${_gc_pj_id}
```
```
### 例

$ gcloud beta compute ssh ${_account}@${_common} \
  --zone ${_zone} \
  --tunnel-through-iap \
  --project ${_gc_pj_id}
WARNING: 

To increase the performance of the tunnel, consider installing NumPy. For instructions,
please see https://cloud.google.com/iap/docs/using-tcp-forwarding#increasing_the_tcp_upload_bandwidth

Warning: Permanently added 'compute.6156427810463326698' (ED25519) to the list of known hosts.
Welcome to Ubuntu 24.04 LTS (GNU/Linux 6.8.0-1011-gcp x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

$
$
$
```

---> SSH ログインが出来れば成功です :)

## 99. クリーンアップ

- GCE Instance の削除

```
gcloud beta compute instances delete ${_common} \
  --zone ${_zone} \
  --project ${_gc_pj_id}
```

- 外部 IP Address の削除

```
gcloud beta compute addresses delete gce-${_common} \
  --region ${_region} \
  --project ${_gc_pj_id}
```

- Firewall Rule の削除

```
gcloud beta compute firewall-rules delete ${_common}-allow-ingress-ssh \
  --project ${_gc_pj_id}

gcloud beta compute firewall-rules delete ${_common}-allow-ingress-iap \
  --project ${_gc_pj_id}

```

- サブネットの削除

```
gcloud beta compute networks subnets delete ${_common} \
  --region ${_region} \
  --project ${_gc_pj_id}
```

- VPC Network の削除

```
gcloud beta compute networks delete ${_common} \
  --project ${_gc_pj_id}
```

- Service Account の削除

```
gcloud beta iam service-accounts delete sa-gce-${_common}@${_gc_pj_id}.iam.gserviceaccount.com \
  --project ${_gc_pj_id}
```
