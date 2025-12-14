# Setting SSH Keys

## GCE の SSH Keys を確認する方法

- 環境変数

```
export _gc_project_id='Your Google Cloud Project ID'
export _vm_name='Your GCE Instance Name'
export _vm_zone='Your GCE Instance Zone'
```

- 確認コマンド
  - https://docs.cloud.google.com/compute/docs/metadata/predefined-metadata-keys?hl=en

```
gcloud beta compute instances describe ${_vm_name} \
  --zone=${_vm_zone} \
  --project=${_gc_project_id} \
  --format="yaml(metadata)"
```

## Google Cloud Project で共通の公開鍵を確認する

https://docs.cloud.google.com/sdk/gcloud/reference/compute/project-info/describe

```
gcloud beta compute project-info describe --project=${_gc_project_id}
```

## Google Cloud Project で共通の公開鍵を追加する


- key を追加する
  - https://docs.cloud.google.com/sdk/gcloud/reference/beta/compute/project-info/add-metadata

```
### 実際の公開鍵の形
ssh-rsa AAAAB3Nz...割愛...A3qfQ== iganari@example.com

### VM 上の Linux User
iganari
```
```
### 実際のコマンド

gcloud beta compute project-info add-metadata --metadata=ssh-keys="iganari:ssh-rsa AAAAB3Nz...割愛...A3qfQ== iganari@example.com"
```

## VM レベル

WIP

## プロジェクトレベルの metadata の SSH Key を許可しない

WIP
