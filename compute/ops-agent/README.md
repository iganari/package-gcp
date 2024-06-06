# Ops Agent について

## 概要

hoge

## インストール方法

https://cloud.google.com/stackdriver/docs/solutions/agents/ops-agent/installation?hl=en#agent-install-latest-linux

- 最新 Ver の Ops Agent をインストールする

```
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
```

- Ops Agent のステータスの確認

```
sudo systemctl status google-cloud-ops-agent"*"
```

## その他必要なこと

- API の有効化

```
gcloud services enable monitoring.googleapis.com --project ${_gc_pj_id}
```

## デフォルトで送信するログ

https://cloud.google.com/stackdriver/docs/solutions/agents/ops-agent/configuration?hl=en#default

## 注意点

GCE に Ops Agent をいれて Cloud Monitoring で監視する場合、以下の Role が必要になる。特に VM の Service Account を個別設定する時は注意すること。

+ Monitoring Metric Writer ( `roles/monitoring.metricWriter` )
+ Logs Writer( `roles/logging.logWriter` )

[公式ドキュメント | Authorize the Ops Agent](https://cloud.google.com/monitoring/agent/ops-agent/authorization#create-service-account)

- ex

```
gcloud beta projects add-iam-policy-binding ${_gc_pj_id} \
  --member="serviceAccount:sa-gce-hogehoge@${_gc_pj_id}.iam.gserviceaccount.com" \
  --role="roles/monitoring.metricWriter" \
  --condition None
```
```
gcloud beta projects add-iam-policy-binding ${_gc_pj_id} \
  --member="serviceAccount:sa-gce-hogehoge@${_gc_pj_id}.iam.gserviceaccount.com" \
  --role="roles/logging.logWriter" \
  --condition None
```

## ローカルのログの確認方法

```
sudo tail -f /var/log/google-cloud-ops-agent/health-checks.log
```

- インストール後に権限周りも正常な場合は以下のようになる

```
$ sudo tail -f /var/log/google-cloud-ops-agent/health-checks.log
{"severity":"INFO","time":"2024-06-06T09:39:24Z","message":"Monitoring API response status: 200 OK"}
{"severity":"INFO","time":"2024-06-06T09:39:24Z","message":"Request to the Monitoring API was successful."}
{"severity":"INFO","time":"2024-06-06T09:39:24Z","message":"dl.google.com response status: 200 OK"}
{"severity":"INFO","time":"2024-06-06T09:39:24Z","message":"Request to dl.google.com was successful."}
{"severity":"INFO","time":"2024-06-06T09:39:24Z","message":"GCE Metadata Server response status: 200 OK"}
{"severity":"INFO","time":"2024-06-06T09:39:24Z","message":"Request to the GCE Metadata server was successful."}
{"severity":"INFO","time":"2024-06-06T09:39:24Z","message":"[Network Check] Result: PASS"}
{"severity":"INFO","time":"2024-06-06T09:39:24Z","message":"monitoring client was created successfully"}
{"severity":"INFO","time":"2024-06-06T09:39:24Z","message":"logging client was created successfully"}
{"severity":"INFO","time":"2024-06-06T09:39:24Z","message":"[API Check] Result: PASS"}
```
