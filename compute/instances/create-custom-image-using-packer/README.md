# Create custom image using Packer

## やること

Packerを使用してカスタムイメージを作成する

以下のバージョンを用います

+ Packer
  + WIP
+ Ansible
  + WIP

## 手順

+ GCP との認証

```
WIP
```

+ GCP の service を有効化

```
WIP
```

+ 任意の値を環境変数にいれる

```
export _project_id='Your GCP Project's ID'
export _region='Your main region'
export _vpc_network_name='Your VPC network's Name'
export _subnet_name='Your subnet's Name'
```

```
### ex

export _project_id='plg-gcp-instance-packer'
export _region='asia-northeast1'
export _vpc_network_name='iganri-test-vpc'
export _subnet_name='iganri-test-subnet'
```


+ ネットワークと Firewall Rules の作成

```
gcloud beta compute networks create ${_vpc_network_name} \
  --subnet-mode=custom
```
```
gcloud beta compute networks subnets create ${_subnet_name} \
  --network ${_vpc_network_name} \
  --region ${_region} \
  --range 172.16.0.0/12
```
```
gcloud compute firewall-rules create allow-ssh-all \
  --direction=INGRESS \
  --priority=1000 \
  --network ${_vpc_network_name} \
  --action=ALLOW \
  --rules=tcp:22,icmp \
  --source-ranges=0.0.0.0/0 \
  --target-tags=allow-ssh-all
```

+ Packer の実行

```
packer build -var-file=variables-centos7.json packer.json
```

## 注意点

+ Cloud Monitoring Agnet を入れる際に、 VM の Access Scorp が Monitoring API を使えるようにしていないと起動に失敗する
