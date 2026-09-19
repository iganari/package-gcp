# Images

## 概要

公式イメージやカスタムイメージについて

## 準備

```
export _gc_pj_id='Your Google Cloud Project ID'
```



## どのような　OS イメージがあるか確認する

+ 基本形

```
gcloud beta compute images list --project ${_gc_pj_id}
```

+ Filter で絞り込む例

```
gcloud compute images list --filter="name~'^rocky-linux-8-optimized-gcp-v.*?'" --format table'(NAME, PROJECT, STATUS)'
```

### Ubuntu 系を検索する

- 該当する Google Cloud プロジェクトにて利用可能なイメージを検索する

```
gcloud beta compute images list --project ${_gc_pj_id}
```

- 該当する Google Cloud プロジェクトにて、プレフィックスが **ubuntu** のイメージを検索する

```
gcloud beta compute images list --filter="name~'^ubuntu-.*?'" --project ${_gc_pj_id}
```

<details>
<summary>実行例</summary>

```
$ gcloud beta compute images list --filter="name~'^ubuntu-.*?'" --project ${_gc_pj_id}
NAME                                                     PROJECT                       FAMILY                                         DEPRECATED  STATUS
ubuntu-accel-2204-amd64-tpu-v5e-v5p-v6e-v20260427        ubuntu-os-accelerator-images  ubuntu-accel-2204-amd64-tpu-v5e-v5p-v6e                    READY
ubuntu-accel-2404-amd64-tpu-tpu7x-v20260422              ubuntu-os-accelerator-images  ubuntu-accel-2404-amd64-tpu-tpu7x                          READY
ubuntu-accelerator-2204-amd64-with-nvidia-570-v20260317  ubuntu-os-accelerator-images  ubuntu-accelerator-2204-amd64-with-nvidia-570              READY
ubuntu-accelerator-2204-amd64-with-nvidia-580-v20260428  ubuntu-os-accelerator-images  ubuntu-accelerator-2204-amd64-with-nvidia-580              READY
ubuntu-accelerator-2204-arm64-with-nvidia-570-v20260317  ubuntu-os-accelerator-images  ubuntu-accelerator-2204-arm64-with-nvidia-570              READY
ubuntu-accelerator-2204-arm64-with-nvidia-580-v20260428  ubuntu-os-accelerator-images  ubuntu-accelerator-2204-arm64-with-nvidia-580              READY
ubuntu-accelerator-2404-amd64-with-nvidia-570-v20260316  ubuntu-os-accelerator-images  ubuntu-accelerator-2404-amd64-with-nvidia-570              READY
ubuntu-accelerator-2404-amd64-with-nvidia-580-v20260418  ubuntu-os-accelerator-images  ubuntu-accelerator-2404-amd64-with-nvidia-580              READY
ubuntu-accelerator-2404-arm64-with-nvidia-570-v20260316  ubuntu-os-accelerator-images  ubuntu-accelerator-2404-arm64-with-nvidia-570              READY
ubuntu-accelerator-2404-arm64-with-nvidia-580-v20260418  ubuntu-os-accelerator-images  ubuntu-accelerator-2404-arm64-with-nvidia-580              READY
ubuntu-minimal-pro-1804-bionic-arm64-v20260421           ubuntu-os-pro-cloud           ubuntu-minimal-pro-1804-lts-arm64                          READY
ubuntu-minimal-pro-1804-bionic-v20260421                 ubuntu-os-pro-cloud           ubuntu-minimal-pro-1804-lts                                READY
ubuntu-minimal-pro-2004-focal-arm64-v20260415            ubuntu-os-pro-cloud           ubuntu-minimal-pro-2004-lts-arm64                          READY
ubuntu-minimal-pro-2004-focal-v20260415                  ubuntu-os-pro-cloud           ubuntu-minimal-pro-2004-lts                                READY
ubuntu-minimal-pro-2204-jammy-arm64-v20260421            ubuntu-os-pro-cloud           ubuntu-minimal-pro-2204-lts-arm64                          READY
ubuntu-minimal-pro-2204-jammy-v20260421                  ubuntu-os-pro-cloud           ubuntu-minimal-pro-2204-lts                                READY
ubuntu-minimal-pro-2404-noble-amd64-v20260422            ubuntu-os-pro-cloud           ubuntu-minimal-pro-2404-lts-amd64                          READY
ubuntu-minimal-pro-2404-noble-arm64-v20260422            ubuntu-os-pro-cloud           ubuntu-minimal-pro-2404-lts-arm64                          READY
ubuntu-minimal-pro-2604-resolute-amd64-v20260421         ubuntu-os-pro-cloud           ubuntu-minimal-pro-2604-lts-amd64                          READY
ubuntu-minimal-pro-2604-resolute-arm64-v20260421         ubuntu-os-pro-cloud           ubuntu-minimal-pro-2604-lts-arm64                          READY
ubuntu-pro-1604-xenial-v20260114                         ubuntu-os-pro-cloud           ubuntu-pro-1604-lts                                        READY
ubuntu-pro-1804-bionic-arm64-v20260421                   ubuntu-os-pro-cloud           ubuntu-pro-1804-lts-arm64                                  READY
ubuntu-pro-1804-bionic-v20260421                         ubuntu-os-pro-cloud           ubuntu-pro-1804-lts                                        READY
ubuntu-pro-2004-focal-arm64-v20260414                    ubuntu-os-pro-cloud           ubuntu-pro-2004-lts-arm64                                  READY
ubuntu-2204-jammy-arm64-v20260427                        ubuntu-os-cloud               ubuntu-2204-lts-arm64                                      READY
ubuntu-pro-2004-focal-v20260414                          ubuntu-os-pro-cloud           ubuntu-pro-2004-lts                                        READY
ubuntu-pro-2204-jammy-arm64-v20260427                    ubuntu-os-pro-cloud           ubuntu-pro-2204-lts-arm64                                  READY
ubuntu-pro-2204-jammy-v20260427                          ubuntu-os-pro-cloud           ubuntu-pro-2204-lts                                        READY
ubuntu-pro-2404-noble-amd64-v20260422                    ubuntu-os-pro-cloud           ubuntu-pro-2404-lts-amd64                                  READY
ubuntu-pro-2404-noble-arm64-v20260422                    ubuntu-os-pro-cloud           ubuntu-pro-2404-lts-arm64                                  READY
ubuntu-pro-2604-resolute-amd64-v20260421                 ubuntu-os-pro-cloud           ubuntu-pro-2604-lts-amd64                                  READY
ubuntu-pro-2604-resolute-arm64-v20260421                 ubuntu-os-pro-cloud           ubuntu-pro-2604-lts-arm64                                  READY
ubuntu-2204-jammy-v20260427                              ubuntu-os-cloud               ubuntu-2204-lts                                            READY
ubuntu-2404-noble-amd64-v20260422                        ubuntu-os-cloud               ubuntu-2404-lts-amd64                                      READY
ubuntu-2404-noble-arm64-v20260422                        ubuntu-os-cloud               ubuntu-2404-lts-arm64                                      READY
ubuntu-2510-questing-amd64-v20260422                     ubuntu-os-cloud               ubuntu-2510-amd64                                          READY
ubuntu-2510-questing-arm64-v20260422                     ubuntu-os-cloud               ubuntu-2510-arm64                                          READY
ubuntu-2604-resolute-amd64-v20260421                     ubuntu-os-cloud               ubuntu-2604-lts-amd64                                      READY
ubuntu-2604-resolute-arm64-v20260421                     ubuntu-os-cloud               ubuntu-2604-lts-arm64                                      READY
ubuntu-pro-fips-1804-bionic-v20260410                    ubuntu-os-pro-cloud           ubuntu-pro-fips-1804-lts                                   READY
ubuntu-pro-fips-2004-focal-v20260420                     ubuntu-os-pro-cloud           ubuntu-pro-fips-2004-lts                                   READY
ubuntu-pro-fips-updates-2204-jammy-arm64-v20260427       ubuntu-os-pro-cloud           ubuntu-pro-fips-updates-2204-lts-arm64                     READY
ubuntu-pro-fips-updates-2204-jammy-v20260427             ubuntu-os-pro-cloud           ubuntu-pro-fips-updates-2204-lts                           READY
ubuntu-minimal-2204-jammy-arm64-v20260427                ubuntu-os-cloud               ubuntu-minimal-2204-lts-arm64                              READY
ubuntu-minimal-2204-jammy-v20260427                      ubuntu-os-cloud               ubuntu-minimal-2204-lts                                    READY
ubuntu-minimal-2404-noble-amd64-v20260422                ubuntu-os-cloud               ubuntu-minimal-2404-lts-amd64                              READY
ubuntu-minimal-2404-noble-arm64-v20260422                ubuntu-os-cloud               ubuntu-minimal-2404-lts-arm64                              READY
ubuntu-minimal-2510-questing-amd64-v20260422             ubuntu-os-cloud               ubuntu-minimal-2510-amd64                                  READY
ubuntu-minimal-2510-questing-arm64-v20260422             ubuntu-os-cloud               ubuntu-minimal-2510-arm64                                  READY
ubuntu-minimal-2604-resolute-amd64-v20260421             ubuntu-os-cloud               ubuntu-minimal-2604-lts-amd64                              READY
ubuntu-minimal-2604-resolute-arm64-v20260421             ubuntu-os-cloud               ubuntu-minimal-2604-lts-arm64                              READY
```

</details>

- AND 条件

```
gcloud beta compute images list --filter="name~'^ubuntu-.*?' AND name~'amd64'" --project ${_gc_pj_id}
```

<details>
<summary>実行例</summary>

```
$ gcloud beta compute images list --filter="name~'^ubuntu-.*?' AND name~'amd64'" --project ${_gc_pj_id}
NAME                                                     PROJECT                       FAMILY                                         DEPRECATED  STATUS
ubuntu-accel-2204-amd64-tpu-v5e-v5p-v6e-v20260427        ubuntu-os-accelerator-images  ubuntu-accel-2204-amd64-tpu-v5e-v5p-v6e                    READY
ubuntu-accel-2404-amd64-tpu-tpu7x-v20260422              ubuntu-os-accelerator-images  ubuntu-accel-2404-amd64-tpu-tpu7x                          READY
ubuntu-accelerator-2204-amd64-with-nvidia-570-v20260317  ubuntu-os-accelerator-images  ubuntu-accelerator-2204-amd64-with-nvidia-570              READY
ubuntu-accelerator-2204-amd64-with-nvidia-580-v20260428  ubuntu-os-accelerator-images  ubuntu-accelerator-2204-amd64-with-nvidia-580              READY
ubuntu-accelerator-2404-amd64-with-nvidia-570-v20260316  ubuntu-os-accelerator-images  ubuntu-accelerator-2404-amd64-with-nvidia-570              READY
ubuntu-accelerator-2404-amd64-with-nvidia-580-v20260418  ubuntu-os-accelerator-images  ubuntu-accelerator-2404-amd64-with-nvidia-580              READY
ubuntu-2404-noble-amd64-v20260422                        ubuntu-os-cloud               ubuntu-2404-lts-amd64                                      READY
ubuntu-2510-questing-amd64-v20260422                     ubuntu-os-cloud               ubuntu-2510-amd64                                          READY
ubuntu-2604-resolute-amd64-v20260421                     ubuntu-os-cloud               ubuntu-2604-lts-amd64                                      READY
ubuntu-minimal-2404-noble-amd64-v20260422                ubuntu-os-cloud               ubuntu-minimal-2404-lts-amd64                              READY
ubuntu-minimal-2510-questing-amd64-v20260422             ubuntu-os-cloud               ubuntu-minimal-2510-amd64                                  READY
ubuntu-minimal-2604-resolute-amd64-v20260421             ubuntu-os-cloud               ubuntu-minimal-2604-lts-amd64                              READY
ubuntu-minimal-pro-2404-noble-amd64-v20260422            ubuntu-os-pro-cloud           ubuntu-minimal-pro-2404-lts-amd64                          READY
ubuntu-minimal-pro-2604-resolute-amd64-v20260421         ubuntu-os-pro-cloud           ubuntu-minimal-pro-2604-lts-amd64                          READY
ubuntu-pro-2404-noble-amd64-v20260422                    ubuntu-os-pro-cloud           ubuntu-pro-2404-lts-amd64                                  READY
ubuntu-pro-2604-resolute-amd64-v20260421                 ubuntu-os-pro-cloud           ubuntu-pro-2604-lts-amd64                                  READY
```

</details>


### Rocky Linux 

- 基本形

```
gcloud beta compute images list --filter="name ~ '^rocky-linux-.*?'" --project ${_gc_pj_id} | grep -v arm64 | grep -v optimized
```

<details>
<summary>実行例</summary>

```
$ gcloud beta compute images list --filter="name ~ '^rocky-linux-.*?'" --project ${_gc_pj_id} | grep -v arm64
NAME                                         PROJECT            FAMILY                             DEPRECATED  STATUS
rocky-linux-8-v20240709                      rocky-linux-cloud  rocky-linux-8                                  READY
rocky-linux-9-v20240709                      rocky-linux-cloud  rocky-linux-9                                  READY
```

</details>


- AND 条件

```
TBD
```

