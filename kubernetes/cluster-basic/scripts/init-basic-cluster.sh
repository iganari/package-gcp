#!/bin/bash

# set -x

### Usage Example
# bash operate-basic-cluster.sh {operation} {GCP Project ID} {Common Value} {Region} {Region ID}
# bash operate-basic-cluster.sh create gcp-iganari-gke-test iganari-test region asia-northeast1-b

# echo $1    ## create or delete
# echo $2    ## Your GCP Project ID
# echo $3    ## Common Value
# echo $4    ## 'region' or 'zone'
# echo $5    ## region id or zone id


# WIP

## Create VPC Network

export     _pj=$(echo $3)
export _common=$(echo $4)
# export _region=$(echo $5)


if [ "$5" = "region" ];then
  echo "hoge"
  export hoge=hoge
elif [ "$5" = "zone"];then
  echo "fuga"
  exprot hoge
else
  echo "Your type is wrong"
fi


create-vpc () {
  gcloud beta compute networks create ${_common}-network \
    --subnet-mode=custom \
    --project ${_pj}
}
check-vpc () {
  gcloud beta compute networks list --project ${_pj} --filter="name=( \"${_common}-network\" )"
  # gcloud beta compute networks list --project ${_pj} | grep ${_common}-network
}

create-subnets () {
  gcloud beta compute networks subnets create ${_common}-subnets \
    --network ${_common}-network \
    --region ${_region} \
    --range 172.16.0.0/12 \
    --project ${_pj}
}
check-subnets () {
  gcloud beta compute networks subnets list \
    --network ${_common}-network \
    --project ${_pj} --filter="name=( \"${_common}-subnets\" )"
}

create-firewall () {
  gcloud beta compute firewall-rules create ${_common}-allow-internal-all \
    --network ${_common}-network \
    --allow tcp:0-65535,udp:0-65535,icmp \
    --project ${_pj}
}
check-firewall () {
  gcloud beta compute firewall-rules list \
    --project ${_pj} --filter="name=( \"${_common}-allow-internal-all\" )"
}

create-cluster () {
  gcloud beta container clusters create ${_common}-zonal \
    --network ${_common}-network \
    --subnetwork ${_common}-subnets \
    --zone ${_region}-a \
    --num-nodes 3 \
    --preemptible \
    --project ${_pj}
}

delete-default-node-pool () {
  gcloud beta container node-pools delete default-pool \
    --cluster ${_common}-zonal \
    --zone ${_region}-a \
    --project ${_pj} \
    -q
}

add-specific-node-pool () {
  gcloud beta container node-pools create ${_common}-zonal-nodepool \
    --cluster ${_common}-zonal \
    --zone ${_region}-a \
    --num-nodes 3 \
    --preemptible \
    --project ${_pj}
}


delete-cluster () {
  gcloud beta container clusters delete ${_common}-zonal \
    --zone ${_region}-a \
    --project ${_pj} \
    -q
}

delete-firewall () {
  gcloud beta compute firewall-rules delete ${_common}-allow-internal-all \
    --project ${_pj} \
    -q
}

delete-subnets () {
  gcloud beta compute networks subnets delete ${_common}-subnets \
    --region ${_region} \
    --project ${_pj} \
    -q
}

delete-vpc () {
  gcloud beta compute networks delete ${_common}-network \
    --project ${_pj} \
    -q
}


### Check Args
if [ "$#" = '5' ]; then
  :
else
  echo "Your usage is wrong :("
  exit 1
fi

### Operation
if [ $1 = 'create' ]; then
  echo "your type is create"

  create-vpc
  check-vpc
  create-subnets
  check-subnets
  create-firewall
  check-firewall
  create-cluster
  delete-default-node-pool
  add-specific-node-pool
  exit 0

elif [ $1 = 'delete' ]; then
  echo "your type is delete"

  delete-cluster && sleep 60
  delete-firewall && sleep 60
  check-firewall
  delete-subnets && sleep 60
  check-subnets
  delete-vpc && sleep 60
  check-vpc
  exit 0

else
  echo "Your type is invalid"
  echo "Please operation is 'create' or 'delete'"
  exit 1
fi
