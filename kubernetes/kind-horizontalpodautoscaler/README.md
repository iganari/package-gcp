# HorizontalPodAutoscaler

:fire: WIP

## 概要

```
水平 Pod 自動スケーリング
HorizontalPodAutoscaler は、ワークロードの CPU やメモリの消費量に応じて、または Kubernetes 内から報告されるカスタム指標あるいはクラスタ外のソースからの外部指標に応じて、Pod の数を自動的に調整することで、Kubernetes ワークロードの形状を変更します。

公式　URL | Horizontal Pod autoscaling
https://cloud.google.com/kubernetes-engine/docs/concepts/horizontalpodautoscaler?hl=en

公式　URL | Configuring horizontal Pod autoscaling
https://cloud.google.com/kubernetes-engine/docs/how-to/horizontal-pod-autoscaling?hl=en
```

## 設定するもの

+ kind
  +  hoge
+ Deployment
  + spec.template.spac.containers.resources.requests
