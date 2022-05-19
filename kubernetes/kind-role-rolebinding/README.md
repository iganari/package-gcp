# kind: Role / RoleBinding / ClusterRole / ClusterRoleBinding

:fire: 要検証項目あり -> [要検証](./README.md#要検証)

## 概要

GKE 上で Kubernetes の RBAC を使うことが出来る

```
Kubernetes の RBAC とは役割ベースのアクセス制御をする機能であり、
Role と ClusterRole は、どのリソースにどんな操作を許可するかを定義するためのリソース

RoleBinding と ClusterRoleBinding はどの Role/ClusterRole を
どの User や ServiceAcctount に紐付けるかを定義するためのリソース
```

+ 公式ドキュメント

```
Using RBAC Authorization | RBAC認可を使用する
https://kubernetes.io/ja/docs/reference/access-authn-authz/rbac/
```
```
Configure role-based access control
https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control
```

Role と RoleBinding, ClusterRole と ClusterRoleBinding がセットになる

Role, ClusterRole が出来ることを定義し、RoleBinding, ClusterRoleBinding で操作者を定義する(紐付ける)

## 制約

K8s の RBAC の制約 -> https://kubernetes.io/ja/docs/reference/access-authn-authz/rbac/#roleとclusterrole

## 準備

### IAM

Project レベルで Permission `container.clusters.get` が必要

この Permission が含まれる Role は `Kubernetes Engine Cluster Viewer(roles/container.clusterViewer)` や `Kubernetes Engine Viewer(roles/container.viewer)` など。

IAM と管理にて付与する必要がありそう

https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control#iam-interaction


## Role と RoleBinding

### サンプル

```
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: pod-reader
  namespace: accounting
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```
```
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: pod-reader-binding
  namespace: accounting
roleRef:
  kind: Role
  apiGroup: rbac.authorization.k8s.io
  name: pod-reader
subjects:
# Google Cloud user account
- kind: User
  name: janedoe@example.com
# Kubernetes service account
- kind: ServiceAccount
  name: johndoe
# GCP IAM service account
- kind: User
  name: test-account@test-project.iam.gserviceaccount.com
# Google Group
- kind: Group
  name: accounting-group@example.com
```

### apiGroups / resources / verbs

[Authorization Overview | Determine the Request Verb](https://kubernetes.io/docs/reference/access-authn-authz/authorization/#determine-the-request-verb) を参照する

参考Qiita -> [KubernetesのRBACについて](https://qiita.com/sheepland/items/67a5bb9b19d8686f389d)

## ClusterRole と ClusterRoleBinding


WIP


## 要検証

グーグルグループを使う際に RoleBinding で指定するだけでいいのか？

確認済みドメインの Google グループのアドレス `gke-security-groups@ドメイン` がよく分かってない -> [Configure Google Groups for RBAC(RBAC 向け Google グループの構成)](https://cloud.google.com/kubernetes-engine/docs/how-to/google-groups-rbac)

## memo

Workload Identity とかは特に関係ない