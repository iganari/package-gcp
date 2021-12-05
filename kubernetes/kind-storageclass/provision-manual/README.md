# 手動で作成した永続ディスクをマウントする

## 概要

```
Provisioning regional persistent disks | Manual provisioning
https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/regional-pd#manual-provisioning
```


## やってみる

```
export _gcp_pj_id='Your GCP Project ID'
export _region='asia-northeast1'
export _zone_1=${_region}-b
export _zone_2=${_region}-c

```
```
gcloud compute disks create pkg-gcp-disk \
  --size 500Gi \
  --region ${_region} \
  --replica-zones ${_zone_1},${_zone_1} \
  --project ${_gcp_pj_id}
```

```
kubectl apply -f main.yaml
```
```
cat << __EOF__ > main.yaml

kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: pkg-gcp-sc
provisioner: pd.csi.storage.gke.io
parameters:
  type: pd-standard
  replication-type: regional-pd
volumeBindingMode: WaitForFirstConsumer
allowedTopologies:
- matchLabelExpressions:
  - key: topology.gke.io/zone
    values:
    - ${_zone_1}
    - ${_zone_2}

---

apiVersion: v1
kind: PersistentVolume
metadata:
  name: pkg-gcp-pv
spec:
  storageClassName: pkg-gcp-sc
  capacity:
     storage: 500Gi
  accessModes:
     - ReadWriteOnce
  claimRef:
    name: pkg-gcp-pvc
    namespace: default
  csi:
    driver: pd.csi.storage.gke.io
    volumeHandle: projects/${_gcp_pj_id}/regions/${_region}/disks/pkg-gcp-disk
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
          - key: topology.gke.io/zone
            operator: In
            values:
               - ${_zone_1}
               - ${_zone_2}

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
  storageClassName: ""             ### must be empty

---

apiVersion: v1
kind: Pod
metadata:
  name: pkg-gcp
  namespace: default
spec:
  volumes:
    - name: pkg-gcp-volume
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
        - name: pkg-gcp-volume
          mountPath: "/usr/share/nginx/html"

__EOF__
```


