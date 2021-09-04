# kind: PriorityClass

## 概要

優先度を定義するオブジェクト

```
PriorityClass
https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#priorityclass
```
```
Adding spare capacity to GKE Autopilot with balloon pods
https://wdenniss.com/gke-autopilot-spare-capacity
```
```
完全マネージドな k8s ! GKE Autopilot を解説する
https://medium.com/google-cloud-jp/gke-autopilot-87f8458ccf74
```

## Balloon Pods

優先度を意図的に低くした Pods を起動しておくことで、K8s のリソースを確保しておく仕組み
