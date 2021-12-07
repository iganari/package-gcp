# リージョン永続ディスクの動的プロビジョニング

## 概要

```
Provisioning regional persistent disks | Dynamic provisioning
https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/regional-pd#dynamic-provisioning
```

## やってみる

+ main.yaml

```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: pkg-gcp-sc
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

---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pkg-gcp-pvc
  namespace: default
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Gi
  storageClassName: pkg-gcp-sc

---

apiVersion: v1
kind: Pod
metadata:
  name: pkg-gcp
  namespace: default
spec:
  volumes:
    - name: pkg-gcp-storage
      persistentVolumeClaim:
        claimName: pkg-gcp-pvc
  containers:
    - name: pkg-gcp-container
      image: nginx:1.21.4
      ports:
        - name: "http-port"
          containerPort: 80
      resources:
        limits:
          cpu: 500m
          memory: 1Gi
        requests:
          cpu: 300m
          memory: 500m
      volumeMounts:
        - name: pkg-gcp-storage
          mountPath: "/usr/share/nginx/html"
```

+ apply

```
kubectl apply -f main.yaml
```
