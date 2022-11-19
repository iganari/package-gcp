# gcloud コマンド



```
export _gcp_pj_id='Your_GCP_Project_ID'
export _common='pkg-gcp'
export _region='asia-northeast1'
```


## オプション `--command`

+ VM に SSH し、コマンドを実行する

```
gcloud compute ssh {_user}@${_vm_name} --zone ${_region}-b --project ${_gcp_pj_id} --command="ps -ejH"
```


## metadata

WIP

## ssh keys

```
gcloud beta compute os-login ssh-keys list --project {PROJECT ID}
```

## Option

### format

出力形式を指定できる


```
gcloud compute instances describe test-instance --format="yaml(name,status,disks)"
```
