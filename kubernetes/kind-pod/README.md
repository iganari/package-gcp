# kind: Pod

## 概要

WIP

## 何もしない Pod 01

[quiet-pod-01](./quiet-pod-01.yaml)

```
kind: Pod
metadata:
  name: quiet-pod-01
spec:
  containers:
  - name: quiet-pod
    image: google/cloud-sdk:slim
    command:
    - tail
    - -f
    - /dev/null
```

## 何もしない Pod 02

[quiet-pod-02](./quiet-pod-02.yaml)

```
kind: Pod
apiVersion: v1
metadata:
  name: quiet-pod-02
spec:
  containers:
  - name: quiet-pod
    image: google/cloud-sdk:slim
    command: ["sleep","infinity"]
```