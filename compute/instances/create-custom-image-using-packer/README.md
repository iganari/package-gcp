# Create custom image using Packer

## 出来ること

Packerを使用してカスタムイメージを作成します

以下のバージョンを用います

+ Packer
  + v1.5.5
+ Ansible
  + WIP

## 手順

+ [ネットワークの作成](./README.md#ネットワークの作成)
+ [Packer の実行](./README.md#packer-の実行)

## ネットワークの作成

+ GCP との認証

```
gcloud auth login
```

+ GCP の service を有効化

```
WIP
```

+ 任意の値を環境変数に代入

```
export _project_id='Your GCP Project's ID'
export _region='Your main region'
export _vpc_network_name='Your VPC network's Name'
export _subnet_name='Your subnet's Name'
```

```
### ex

export _project_id='pkg-gcp-instance-packer'
export _region='asia-northeast1'
export _vpc_network_name='iganari-test-vpc'
export _subnet_name='iganari-test-subnet'
export _firewall_name='allow-ssh-all'
```

+ ネットワークと Firewall Rules の作成

```
gcloud beta compute networks create ${_vpc_network_name} \
  --project ${_project_id} \
  --bgp-routing-mode=global \
  --subnet-mode=custom
```
```
gcloud beta compute networks subnets create ${_subnet_name} \
  --project ${_project_id} \
  --network ${_vpc_network_name} \
  --region ${_region} \
  --range 172.16.0.0/12
```
```
gcloud compute firewall-rules create ${_firewall_name} \
  --project ${_project_id} \
  --direction=INGRESS \
  --priority=1000 \
  --network ${_vpc_network_name} \
  --action=ALLOW \
  --rules=tcp:22,icmp \
  --source-ranges=0.0.0.0/0 \
  --target-tags=allow-ssh-all
```

## Packer の実行

+ Packer 実行のための GCP 認証

```
gcloud auth application-default login
```

+ Packer の実行

```
### CentOS 7 の場合

packer build -var-file=variables-centos7.json packer.json
```
```
### Ubuntu 18.04 の場合

packer build -var-file=variables-ubuntu1910.json packer.json
```

+ カスタムイメージの確認

```
# gcloud beta compute images list --project ${_project_id} --filter="name~'^pkg'"
NAME                                                  PROJECT                  FAMILY  DEPRECATED  STATUS
pkg-gcp-custom-image-centos7-2020-05-04t01-19-27z     pkg-gcp-instance-packer                      READY
pkg-gcp-custom-image-ubuntu1910-2020-05-04t01-51-54z  pkg-gcp-instance-packer                      READY
```


## 注意点

Cloud Monitoring Agnet を入れる際に、インスタンスの Access Scorp が Monitoring API を使えるように設定しておかないと systemd の起動時に失敗してしまうので、許可しておく必要があります

+ [packer による設定例(カスタムインスタンス作成時のみ全許可)](./packer.json#L14-L15)

```
"scopes": [
  "https://www.googleapis.com/auth/cloud-platform"
]
```
