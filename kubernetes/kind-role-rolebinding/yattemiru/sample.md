# やってみる

## GKE Cluster の作成

GKE autopilot を作っている

https://github.com/iganari/package-gcp/tree/main/kubernetes/cluster-overview/autopilot-private-gcloud


---> 認証までやる

## Pod を配置

以下のマニフェストを実行する

参考 https://github.com/iganari/package-gcp/tree/main/kubernetes/kind-pod

```
kubectl apply -f rule-sampleyaml
```

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