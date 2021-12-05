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







__EOF__

```
