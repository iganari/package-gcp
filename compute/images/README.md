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

### Ubuntu

- hoge
  - **ubuntu**

```
gcloud beta compute images list --project ${_gc_pj_id}
```
```
gcloud beta compute images list --filter="name~'^ubuntu-.*?'" --project ${_gc_pj_id}
```

<details>
<summary>実行例</summary>


```
$ gcloud beta compute images list --filter="name~'^ubuntu-.*?'" --project ${_gc_pj_id}

NAME                                         PROJECT              FAMILY                         DEPRECATED  STATUS
ubuntu-pro-1604-xenial-v20240703             ubuntu-os-pro-cloud  ubuntu-pro-1604-lts                        READY
ubuntu-pro-1804-bionic-arm64-v20240711       ubuntu-os-pro-cloud  ubuntu-pro-1804-lts-arm64                  READY
ubuntu-pro-1804-bionic-v20240711             ubuntu-os-pro-cloud  ubuntu-pro-1804-lts                        READY
ubuntu-pro-2004-focal-arm64-v20240710        ubuntu-os-pro-cloud  ubuntu-pro-2004-lts-arm64                  READY
ubuntu-pro-2004-focal-v20240710              ubuntu-os-pro-cloud  ubuntu-pro-2004-lts                        READY
ubuntu-pro-2204-jammy-arm64-v20240701        ubuntu-os-pro-cloud  ubuntu-pro-2204-lts-arm64                  READY
ubuntu-pro-2204-jammy-v20240701              ubuntu-os-pro-cloud  ubuntu-pro-2204-lts                        READY
ubuntu-pro-2404-noble-amd64-v20240701a       ubuntu-os-pro-cloud  ubuntu-pro-2404-lts-amd64                  READY
ubuntu-pro-2404-noble-arm64-v20240701a       ubuntu-os-pro-cloud  ubuntu-pro-2404-lts-arm64                  READY
ubuntu-pro-fips-1804-bionic-v20240712        ubuntu-os-pro-cloud  ubuntu-pro-fips-1804-lts                   READY
ubuntu-pro-fips-2004-focal-v20240701         ubuntu-os-pro-cloud  ubuntu-pro-fips-2004-lts                   READY
ubuntu-2004-focal-arm64-v20240614            ubuntu-os-cloud      ubuntu-2004-lts-arm64                      READY
ubuntu-2004-focal-v20240614                  ubuntu-os-cloud      ubuntu-2004-lts                            READY
ubuntu-2204-jammy-arm64-v20240701            ubuntu-os-cloud      ubuntu-2204-lts-arm64                      READY
ubuntu-2204-jammy-v20240701                  ubuntu-os-cloud      ubuntu-2204-lts                            READY
ubuntu-2310-mantic-amd64-v20240701           ubuntu-os-cloud      ubuntu-2310-amd64                          READY
ubuntu-2310-mantic-arm64-v20240701           ubuntu-os-cloud      ubuntu-2310-arm64                          READY
ubuntu-2404-noble-amd64-v20240711            ubuntu-os-cloud      ubuntu-2404-lts-amd64                      READY
ubuntu-2404-noble-arm64-v20240711            ubuntu-os-cloud      ubuntu-2404-lts-arm64                      READY
ubuntu-minimal-2004-focal-arm64-v20240714    ubuntu-os-cloud      ubuntu-minimal-2004-lts-arm64              READY
ubuntu-minimal-2004-focal-v20240714          ubuntu-os-cloud      ubuntu-minimal-2004-lts                    READY
ubuntu-minimal-2204-jammy-arm64-v20240713    ubuntu-os-cloud      ubuntu-minimal-2204-lts-arm64              READY
ubuntu-minimal-2204-jammy-v20240713          ubuntu-os-cloud      ubuntu-minimal-2204-lts                    READY
ubuntu-minimal-2310-mantic-amd64-v20240701a  ubuntu-os-cloud      ubuntu-minimal-2310-amd64                  READY
ubuntu-minimal-2310-mantic-arm64-v20240701a  ubuntu-os-cloud      ubuntu-minimal-2310-arm64                  READY
ubuntu-minimal-2404-noble-amd64-v20240709    ubuntu-os-cloud      ubuntu-minimal-2404-lts-amd64              READY
ubuntu-minimal-2404-noble-arm64-v20240709    ubuntu-os-cloud      ubuntu-minimal-2404-lts-arm64              READY
```

</details>

- AND 条件

```
gcloud beta compute images list --filter="name~'^ubuntu-.*?' AND name~'amd64'" --project ${_gc_pj_id}
```
```
$ gcloud beta compute images list --filter="name~'^ubuntu-.*?' AND name~'amd64'" --project ${_gc_pj_id}

NAME                                         PROJECT              FAMILY                         DEPRECATED  STATUS
ubuntu-2310-mantic-amd64-v20240701           ubuntu-os-cloud      ubuntu-2310-amd64                          READY
ubuntu-2404-noble-amd64-v20240711            ubuntu-os-cloud      ubuntu-2404-lts-amd64                      READY
ubuntu-minimal-2310-mantic-amd64-v20240701a  ubuntu-os-cloud      ubuntu-minimal-2310-amd64                  READY
ubuntu-minimal-2404-noble-amd64-v20240709    ubuntu-os-cloud      ubuntu-minimal-2404-lts-amd64              READY
ubuntu-pro-2404-noble-amd64-v20240701a       ubuntu-os-pro-cloud  ubuntu-pro-2404-lts-amd64                  READY
```

- memo

```
gcloud beta compute images list --filter="name ~ '^rocky-linux-.*?'" --project ${_gc_pj_id} | grep -v arm64
```
