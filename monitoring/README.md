# Monitoring

## 概要

Google Cloud の備え付けの監視ツール

+ 事前に用意されたダッシュボードがある
  + 自身でダッシュボードをカスタム作成することも出来る
+ GCE に Ops Agent をいれることで詳細なメトリクスを取得可能
+ Uptime Check ( 外形監視 ) が簡単に実装可能
+ しきい値設定によるアラーティングの設定が可能 -> Mail や Slack などに通知が可能

```
Cloud Monitoring
https://cloud.google.com/monitoring
```

[![](https://img.youtube.com/vi/7BLV24noNGc/0.jpg)](https://www.youtube.com/watch?v=7BLV24noNGc)


## 複数の GC Project を横断的に見ることが出来る **マルチプロジェクトモニタリング**

```
マルチプロジェクトの Cloud Monitoring がより簡単に
https://cloud.google.com/blog/ja/products/operations/multi-project-cloud-monitoring-made-easier/
```
```
複数のプロジェクトの指標スコープを構成する
https://cloud.google.com/monitoring/settings/multiple-projects
```


## Installing on Linux

+ 公式ドキュメント

https://cloud.google.com/monitoring/agent/install-agent?hl=en

---> Ops Agent に切り替わりました

[Ops Agent overview](https://cloud.google.com/stackdriver/docs/solutions/agents/ops-agent)

## プロセスを監視したい

### Linux のプロセス監視

+ https://cloud.google.com/monitoring/alerts/ui-conditions-ga?hl=ja#process-health
+ https://cloud.google.com/monitoring/api/metrics_opsagent#agent-processes

### Windows のプロセス監視

現状無理

## Tips

SSL 証明書の期限切れをお知らせしてくれる -> https://cloud.google.com/monitoring/alerts/policies-in-json?hl=ja#json-uptime
