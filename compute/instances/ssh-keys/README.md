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
  - https://docs.cloud.google.com/sdk/gcloud/reference/compute/instances/add-metadata


```
gcloud beta project-info add-metadata --metadata-from-file=ssh-keys=KEY_FILE
```
```
gcloud beta compute instances add-metadata ${_vm_name} \
  --zone=${_vm_zone} \
  --project=${_gc_project_id} \
  --metadata=ssh-keys="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCuKuvyOhV/GRjFJPjFwZg3QsDFd3Uisct8nnP+WFHsw9sPDjJ4AZyT30BjgjwxJSrw+sMi5NxTbLpaHochDL4aA+ekH30Nr5CQjOKlySa6ifXT/GkQIieczAD/4NuMd7b4bBBP2EeYz2LbtiFCyW/tiDwXR56NDuPhmbBg8QAo1tncx5Pg/S9/75XjKqf9M6mI2v1yWdTfMll2ZrKgHKmOmKiHKRx0LQZYUCe00ScAxDQmhsl5tnXZsQ/9tB8Ih6G8Ds7IrDyV4Nea4MORwBJXyDLtLqS/b+TXAXIP8V+xU3U6Lqu/t0NgD/eT3OH0iu9xy0w+667ToUITY5ndo5iWGSzK6HatnyjPiCfQpV6zhd1Np/0TNLHB6PpsNJg9lMvA8gakfUOa2wA7VHCIElSyCPT0aJvarJi+tT4dbJa0T6599XYshSfvjBJHyVChXmPB70XmXg4VVjOhM8rUV2HA0/9R7TZTJJUUUPuBF1pNXXekNwIDUjZ3hSqYAel2lch8xEg9XW9dbdoPllvS9GNZUSVBorBzgU3XLzFQNivBeXKq2JYRKc6VJwFX8zU0IzldVrEhmd2BfkRGlyBDvBbw/M3iTcMUSxHWgefclqjVFyp886uyIwu6jR7cG1yYUmeO9kSgGPz2UpmJI3RXC/T4PgasI5Ch2JmloiRrWA3qfQ== iganari@hejda.org"
```

```
cat ssh-key-pub
```
```
gcloud beta compute os-login ssh-keys add \
  --key-file=./ssh-key-pub \
  --project=${_gc_project_id}
```



export _gc_project_id='hejda-tech-2025-prd'
export _vm_name='ws-hejda'
export _vm_zone='asia-northeast1-c'
