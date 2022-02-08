# kind: StatefulSet

## 概要

kind: StatefulSet のサンプルコード

+ StatefulSet は基本的に `replicas: 1` で運用するが多い
  + 基本的に水平スケールを必要としないアプリに使うことが多いため

## StatefulSet とは

WIP

##  StatefulSet を使うメリット

WIP

## 複数 zone 構成の GKE Cluster で使用する場合

StatefulSet においても、紐付ける Disk と Pod の Zone を一致させておく必要がある

しかし、 Node の Zone を特定の Zone のみにしてしまうと耐障害性が下がってしまったり、DR の観点的にも良くない

以下のどれかをすると良い

+ [リージョン永続ディスクの動的プロビジョニングし、 GKE 上の Pod でマウントする方法](./persistent-volumes-regional-pd-dynamic-provisioning)
+ [既存の永続ディスクを PersistentVolume として使用する](./persistent-volumes-preexisting-pd)


## [nginx](./nginx)

WIP

## [mysql](./mysql)

WIP

kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: regionalpd-storageclass
provisioner: pd.csi.storage.gke.io
parameters:
  type: pd-standard
  replication-type: regional-pd
volumeBindingMode: WaitForFirstConsumer
allowedTopologies:
- matchLabelExpressions:
  - key: topology.gke.io/zone
    values:
    - europe-west1-b
    - europe-west1-c