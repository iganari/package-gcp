# Instance Schedules

## 概要

https://cloud.google.com/compute/docs/instances/schedule-instance-start-stop

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/compute/instances/instanceSchedules/2024-instance-schedules-movie.gif)


## やってみる

### サンプルの GCE を作成

- 環境変数

```
export _gc_pj_id='Your Google Cloud Project ID'
export _common='pkg-gcp-is'
export _default_region='asia-northeast1'
export _another_region='us-central1'
export _default_sub_network_range='10.1.0.0/16'
export _another_sub_network_range='10.2.0.0/16'
```

- VPC Network

```
gcloud beta compute networks create ${_common} \
  --subnet-mode custom \
  --project ${_gc_pj_id}
```

- Subnet の作成

```
### asia-northeast1
gcloud beta compute networks subnets create ${_common}-${_default_region} \
  --network ${_common} \
  --region ${_default_region} \
  --range ${_default_sub_network_range} \
  --enable-private-ip-google-access \
  --project ${_gc_pj_id}


### us-central1
gcloud beta compute networks subnets create ${_common}-${_another_region} \
  --network ${_common} \
  --region ${_another_region} \
  --range ${_another_sub_network_range} \
  --enable-private-ip-google-access \
  --project ${_gc_pj_id}
```

- GCE Instance の作成

```
### asia-northeast1
gcloud beta compute instances create ${_common}-${_default_region} \
  --zone ${_default_region}-b \
  --machine-type e2-small \
  --network-interface=stack-type=IPV4_ONLY,subnet=${_common}-${_default_region},no-address \
  --maintenance-policy MIGRATE \
  --provisioning-model STANDARD \
  --no-service-account \
  --no-scopes \
  --create-disk=auto-delete=yes,boot=yes,device-name=${_common}-${_default_region},image=projects/debian-cloud/global/images/debian-12-bookworm-v20240617,mode=rw,size=10,type=projects/${_gc_pj_id}/zones/${_default_region}-b/diskTypes/pd-balanced \
  --shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring \
  --reservation-affinity any \
  --project ${_gc_pj_id}


### us-central1
gcloud beta compute instances create ${_common}-${_another_region} \
  --zone ${_another_region}-c \
  --machine-type e2-small \
  --network-interface=stack-type=IPV4_ONLY,subnet=${_common}-${_another_region},no-address \
  --maintenance-policy MIGRATE \
  --provisioning-model STANDARD \
  --no-service-account \
  --no-scopes \
  --create-disk=auto-delete=yes,boot=yes,device-name=${_common}-${_another_region},image=projects/debian-cloud/global/images/debian-12-bookworm-v20240617,mode=rw,size=10,type=projects/${_gc_pj_id}/zones/${_another_region}-c/diskTypes/pd-balanced \
  --shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring \
  --reservation-affinity any \
  --project ${_gc_pj_id}
```

- Instance Schedules の作成

```
gcloud beta compute resource-policies create instance-schedule ${_default_region}-start08-end20-daily \
  --description='[東京リージョン] 8時に起動|20時に停止' \
  --region ${_default_region} \
  --vm-start-schedule='0 8 * * *' \
  --vm-stop-schedule='0 20 * * *' \
  --timezone='Asia/Tokyo' \
  --project ${_gc_pj_id}


gcloud beta compute resource-policies create instance-schedule ${_another_region}-start10-end16-wed \
  --description='[アイオワリージョン] 10時に起動|16時に停止' \
  --region ${_another_region} \
  --vm-start-schedule='0 10 * * 3' \
  --vm-stop-schedule='0 16 * * 3' \
  --timezone='America/Chicago' \
  --project ${_gc_pj_id}
```

- Instance Schedules で利用する Service Account に、以下の Role が必要
  - Compute Engine Service Agent: `service-{{ Google Cloud Project Number }}@compute-system.iam.gserviceaccount.com` に Role: `Compute Instance Admin (beta) (roles/compute.instanceAdmin)` を付与する

```
export _gc_pj_num=`gcloud beta projects describe ${_gc_pj_id} --format="value(projectNumber)"`

gcloud beta projects add-iam-policy-binding ${_gc_pj_id} \
  --member="serviceAccount:service-${_gc_pj_num}@compute-system.iam.gserviceaccount.com" \
  --role="roles/compute.instanceAdmin" \
  --condition None
```

- Instance Schedules を GCE Instance にアタッチする必要がある
  - VM 新規作成時および既存の VM にアタッチすることが出来る
  - https://cloud.google.com/compute/docs/instances/schedule-instance-start-stop#attaching_to_an_existing_VM

```
### 東京リージョンの GCE に、東京リージョンの Instance Schedule を追加

gcloud compute instances add-resource-policies ${_common}-${_default_region} \
  --resource-policies ${_default_region}-start08-end20-daily \
  --zone ${_default_region}-b \
  --project ${_gc_pj_id}
```
```
### アイオワリージョンの GCE に、アイオワリージョンの Instance Schedule を追加

gcloud compute instances add-resource-policies ${_common}-${_another_region} \
  --resource-policies ${_another_region}-start10-end16-wed \
  --zone ${_another_region}-c \
  --project ${_gc_pj_id}
```

### スクリーンショット

<details>
<summary>GCE Instance</summary>

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/compute/instances/instanceSchedules/2024-instance-schedules-01.png)

</details>

<details>
<summary>Instance Schedules</summary>

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/compute/instances/instanceSchedules/2024-instance-schedules-02.png)

</details>

<details>
<summary>Instance Schedule の詳細 <東京リージョン></summary>

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/compute/instances/instanceSchedules/2024-instance-schedules-03.png)

</details>

<details>
<summary>Instance Schedule の詳細 <アイオワリージョン></summary>

![](https://raw.githubusercontent.com/iganari/artifacts/main/googlecloud/compute/instances/instanceSchedules/2024-instance-schedules-04.png)

</details>
