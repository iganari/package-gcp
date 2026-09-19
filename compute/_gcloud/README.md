# gcloud コマンド



```
export _gc_pj_id='Your　Google Cloud Project ID'
export _common='pkg-gcp'
export _region='asia-northeast1'
```


## オプション `--command`

+ VM に SSH し、コマンドを実行する

```
gcloud compute ssh {_user}@${_vm_name} --zone ${_region}-b --project ${_gc_pj_id} --command="ps -ejH"
```


## metadata

+ VM Instance の中から Project ID を取得する

```
curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/project/project-id"
```

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
