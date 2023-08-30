# Ops Agent について

## 概要


hoge

## デフォルトで送信するログ

https://cloud.google.com/stackdriver/docs/solutions/agents/ops-agent/configuration?hl=en#default

## 注意点

GCE に Ops Agent をいれて Cloud Monitoring で監視する場合、以下の Role が必要になる。特に VM の Service Account を個別設定する時は注意すること。

+ Monitoring Metric Writer ( `roles/monitoring.metricWriter` )
+ Logs Writer( `roles/logging.logWriter` )

[公式ドキュメント | Authorize the Ops Agent](https://cloud.google.com/monitoring/agent/ops-agent/authorization#create-service-account)
