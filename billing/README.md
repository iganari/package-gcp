# Billing

## 請求される料金

### Cloud Monitoring

```
Cloud Monitoring
https://cloud.google.com/stackdriver/pricing#monitoring-costs

Cloud Monitoring の料金の概要
https://cloud.google.com/stackdriver/pricing#monitoring-pricing-summary
```

## Export Cloud Billing について

+ 公式ドキュメント

```
# Cloud Billing データを BigQuery にエクスポートする
https://cloud.google.com/billing/docs/how-to/export-data-bigquery
```

+ :warning: 注意点

この設定は Google Cloud Project ではなく、請求先アカウントに紐づく

故に Google Cloud Project 毎に Export する BQ の Dataset を変えたい場合は、紐づけている請求先アカウントも変更しないといけない

また、 Export 先を複数設定することが **出来ない** ので注意する
