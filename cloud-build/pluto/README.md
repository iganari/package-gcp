# Pluto by Fairwinds を Cloud Build 上で実行する

## 概要

Pluto は　Kubernetes のマニフェストの中で `Deprecated` や `REMOVED` を検出する OSS 

これを Cloud Build 上で(定期的に)実行することで、事前に API が古くなっていることを検出することが出来る


[GitHub | Pluto by Fairwinds](https://github.com/FairwindsOps/pluto)

## サンプル

+ cloudbuild.yaml

```
steps:
  - id: 'Check Deprecations'
    name: 'ubuntu:latest'
    entrypoint: bash
    dir: ${_MANIFEST_DIR}
    args:
      - -c
      - |
        set -eu
        apt update && apt install -y wget
        wget https://github.com/FairwindsOps/pluto/releases/download/v${_PLUTO_VERSION}/pluto_${_PLUTO_VERSION}_linux_amd64.tar.gz
        tar -zxvf pluto_${_PLUTO_VERSION}_linux_amd64.tar.gz
        chmod +x pluto
        ./pluto detect-files --output wide --directory ./
substitutions:
  _MANIFEST_DIR: 'builds/pluto'
  _PLUTO_VERSION: '5.7.0'
```

+ test-deprecated.yaml
  + 敢えて古い API を使ってるマニフェスト

```
apiVersion: batch/v1beta1 ## Deprecated API
# apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "* * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            command:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure
```
