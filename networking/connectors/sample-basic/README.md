# ベーシックサンプル

```

```

- 事前に必要なもの
  - VPC Network
  - Subnet (Region) ?


## サンプル

```
export _
```



### サブネットを指定しない場合

```
export _vpc_access_range='10.4.0.0/28'   ## VPC Network 内で重複しないように。
```


```
gcloud compute networks vpc-access connectors create ${_common} \
  --region ${_default_region} \
  --network ${_common} \
  --range=${_vpc_access_range} \
  --min-instances 2 \
  --max-instances 10 \
  --machine-type e2-micro \
  --project ${_gc_pj_id}
```


### サブネットを指定する場合

TBD
