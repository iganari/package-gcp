# Provisioning regional persistent disks | Dynamic provisioning

## 概要

WIP


[GKE | Provisioning regional persistent disks](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/regional-pd#dynamic-provisioning)

## やってみる

### GKE Cluster と認証する

+ [ ] の中は任意の値に変更してください

```
gcloud container clusters get-credentials [ GKE Cluster Name ] --zone [ GKE Cluster Zone ] --project [ GPC Project ID ]
```

### StorageClass を作る

```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: pkg-gcp
  namespace: default
provisioner: pd.csi.storage.gke.io
parameters:
  type: pd-standard
  replication-type: regional-pd
volumeBindingMode: WaitForFirstConsumer
allowedTopologies:
- matchLabelExpressions:
  - key: topology.gke.io/zone
    values:
    - asia-northeast1-a
    - asia-northeast1-b
    - asia-northeast1-c
```

### StatefulSet でマウントする

```
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: pkg-gcp
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: pkg-gcp
  serviceName: pkg-gcp
  volumeClaimTemplates:
  - metadata:
      name: pkg-gcp
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 300Gi
      storageClassName: pkg-gcp
  template:
    metadata:
      labels:
        app: pkg-gcp
    spec:
      containers:
      - name: pkg-gcp
        image: nginx:1.21.4
        resources:
          limits:
            cpu: 500m
            memory: 1Gi
          requests:
            cpu: 300m
            memory: 500m
        volumeMounts:
        - name: pkg-gcp
          mountPath: "/usr/share/nginx/html"
```

### クリーンナップ

```
kubectl delete StatefulSet pkg-gcp
kubectl delete StorageClass pkg-gcp
```
