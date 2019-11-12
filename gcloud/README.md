# WIP



+ VPC ネットワーク作成

```
### めんどくさい人向け(非推奨)

gcloud compute networks create auto-network --subnet-mode auto
```

```
### 日本 に限定して VPC ネットワークの作成

gcloud compute networks create custom-network1 --subnet-mode custom

gcloud compute networks subnets create subnets-us-central-192 --network custom-network1 --region us-central1 --range 192.168.1.0/24
gcloud compute networks subnets create subnets-europe-west-192 --network custom-network1 --region europe-west1 --range 192.168.5.0/24
gcloud compute networks subnets create subnets-asia-east-192 --network custom-network1 --region asia-east1 --range 192.168.7.0/24
```