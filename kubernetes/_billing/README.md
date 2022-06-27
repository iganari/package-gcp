# Billing


## 料金について

```
Google Kubernetes Engine の料金
https://cloud.google.com/kubernetes-engine/pricing
```

+ クラスタの管理費 ( ※ Standard mode / Autopilot mode に掛からわず )
  + `$0.10 per cluster per hour` = `$72/month`
  + 秒課金
+ Standard mode
  + Node の料金
+ Autopilot mode
  + Pod が使用している vCPU と Memory の料金
+ 通信費など









## Namespace 毎にコストを可視化する方法

[Google Cloud Skills Boost | Managing a GKE Multi-tenant Cluster with Namespaces](https://www.cloudskillsboost.google/focuses/14861?locale=ja&parent=catalog)

[クラスタ リソースの使用方法について](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-usage-metering)

[Cloud Monitoring を使用して費用の最適化のための GKE クラスタをモニタリング](https://cloud.google.com/architecture/monitoring-gke-clusters-for-cost-optimization-using-cloud-monitoring)
