# gcloud instances

## 概要

gcloud instances コマンドの使い方など

gcloud 自体は hoge

## Boot Disk で指定できる Disk を探す

+ 基本形

```
gcloud beta compute images list --project { Your GCP Project ID }
```

+ Filter を使う

```
# gcloud beta compute images list --filter=ubuntu --project { Your GCP Project ID }
NAME                                        PROJECT              FAMILY                         DEPRECATED  STATUS
ubuntu-1804-bionic-arm64-v20220712          ubuntu-os-cloud      ubuntu-1804-lts-arm64                      READY
ubuntu-1804-bionic-v20220712                ubuntu-os-cloud      ubuntu-1804-lts                            READY
ubuntu-pro-1604-xenial-v20211213            ubuntu-os-pro-cloud  ubuntu-pro-1604-lts                        READY
ubuntu-pro-1804-bionic-v20220510            ubuntu-os-pro-cloud  ubuntu-pro-1804-lts                        READY
ubuntu-pro-2004-focal-v20220715             ubuntu-os-pro-cloud  ubuntu-pro-2004-lts                        READY
ubuntu-pro-2204-jammy-v20220622             ubuntu-os-pro-cloud  ubuntu-pro-2204-lts                        READY
ubuntu-pro-fips-1804-bionic-v20220708       ubuntu-os-pro-cloud  ubuntu-pro-fips-1804-lts                   READY
ubuntu-pro-fips-2004-focal-v20220705        ubuntu-os-pro-cloud  ubuntu-pro-fips-2004-lts                   READY
ubuntu-2004-focal-arm64-v20220712           ubuntu-os-cloud      ubuntu-2004-lts-arm64                      READY
ubuntu-2004-focal-v20220712                 ubuntu-os-cloud      ubuntu-2004-lts                            READY
ubuntu-2204-jammy-arm64-v20220712a          ubuntu-os-cloud      ubuntu-2204-lts-arm64                      READY
ubuntu-2204-jammy-v20220712a                ubuntu-os-cloud      ubuntu-2204-lts                            READY
ubuntu-minimal-1804-bionic-arm64-v20220726  ubuntu-os-cloud      ubuntu-minimal-1804-lts-arm64              READY
ubuntu-minimal-1804-bionic-v20220726        ubuntu-os-cloud      ubuntu-minimal-1804-lts                    READY
ubuntu-minimal-2004-focal-arm64-v20220713   ubuntu-os-cloud      ubuntu-minimal-2004-lts-arm64              READY
ubuntu-minimal-2004-focal-v20220713         ubuntu-os-cloud      ubuntu-minimal-2004-lts                    READY
ubuntu-minimal-2204-jammy-arm64-v20220712   ubuntu-os-cloud      ubuntu-minimal-2204-lts-arm64              READY
ubuntu-minimal-2204-jammy-v20220712         ubuntu-os-cloud      ubuntu-minimal-2204-lts                    READY
```
