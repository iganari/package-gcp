# Setting SSH Keys

## GCE の SSH Keys を確認する方法

- 環境変数

```
export _gc_project_id='Your Google Cloud Project ID'
export _vm_name='Your GCE Instance Name'
export _vm_zone='Your GCE Instance Zone'
```

- 確認コマンド

```
gcloud beta compute instances describe ${_vm_name} \
  --zone=${_vm_zone} \
  --project=${_gc_project_id}
```



export _gc_project_id='hejda-tech-2025-prd'
export _vm_name='ws-hejda'
export _vm_zone='asia-northeast1-c'
