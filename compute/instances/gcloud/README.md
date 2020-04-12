# Compute Engine using gcloud

## Prepare env

+ :whale: Setting gcloud configure

```
export _my_project_id='your-project-id'
```
```
gcloud config configurations create ${_my_project_id}
gcloud config set compute/region asia-northeast1
gcloud config set compute/zone asia-northeast1-a
gcloud config set project ${_my_project_id}
```
```
gcloud config configurations list
```

+ Auth GCP

```
gcloud auth login
```

## Create Instance

+ Setting env

```
export _common_name='iganari-test'
export _region='asia-northeast1'
```

+ Create VPC Network

```
gcloud compute networks create ${_common_name}-nw \
  --subnet-mode=custom
```

+ Create Subnet

```
gcloud beta compute networks subnets create ${_common_name}-sb \
  --network ${_common_name}-nw \
  --region ${_region} \
  --range 172.16.0.0/12
```

+ Create Firewall Rules

```
gcloud compute firewall-rules create ${_common_name}-nw-allow-internal \
  --direction=INGRESS \
  --priority=1000 \
  --network ${_common_name}-nw \
  --action=ALLOW \
  --rules=tcp:22,icmp \
  --source-ranges=0.0.0.0/0 \
  --target-tags=${_common_name}-nw-allow-internal
```


+ Create instance

```
gcloud beta compute instances create ${_common_name}-vm \
    --project=${_my_project_id} \
    --zone=${${_region}}-a \
    --machine-type=n1-standard-1 \
    --subnet=${_common_name}-sb \
    --network-tier=PREMIUM \
    --tags=${_common_name}-nw-allow-internal \
    --no-restart-on-failure \
    --maintenance-policy=TERMINATE \
    --preemptible \
    --service-account=$(gcloud iam service-accounts list | grep 'Compute\ Engine\ default\ service\ account' | awk '{print $6}') \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --image=ubuntu-1804-bionic-v20200317 \
    --image-project=ubuntu-os-cloud \
    --boot-disk-size=30GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=vm-test \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --reservation-affinity=any
```

+ Login instance by SSH

```
gcloud compute ssh ${_common_name}-vm --zone ${_region}-a
```


## Delete

+ Delete instance

```
gcloud beta compute instances delete ${_common_name}-vm
```

+ Delete Firewall Rules

```
gcloud compute firewall-rules delete ${_common_name}-nw-allow-internal
```

+ Delete subnet

```
gcloud beta compute networks subnets delete ${_common_name}-sb
```

+ Delete VPC network

```
gcloud compute networks delete ${_common_name}-nw
```
