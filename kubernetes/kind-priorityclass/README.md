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

```
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: balloon-priority
value: -100
preemptionPolicy: Never
globalDefault: false
description: "Balloon Pod Priority."

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: balloon-deploy
spec:
  replicas: 3
  selector:
    matchLabels:
      app: balloon
  template:
    metadata:
      labels:
        app: balloon
    spec:
      priorityClassName: balloon-priority
      terminationGracePeriodSeconds: 0
      containers:
      - name: alpine
        image: alpine:latest
        command: ["sleep"]
        args: ["infinity"]
        resources:
            requests:
              cpu: 1
              memory: 1G
```
