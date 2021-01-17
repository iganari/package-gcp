# External IP addresses

## 種類

+ region
+ global

## region

+ 使用例
    + Cloud NAT

```
gcloud beta compute addresses create ${_common}-ip-addr \
    --region ${_region} \
    --project ${_gcp_pj_id}
```

## global

+ 使用例
    + GCLB

```
gcloud beta compute addresses create mix-ip-addr \
    --ip-version=IPV4 \
    --global \
    --project ${_gcp_pj_id}
```
