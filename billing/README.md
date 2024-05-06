# Billing


## 請求先アカウントについて

- 組織に紐づくリソース

### 必要なRole

- 請求先アカウントを作成する Role
  - Billing Account Administrator (roles/billing.admin)
    - 組織に紐づく請求先アカウント全体を見ることが出来る
  - Billing Account Creator　(roles/billing.creator)
    - 自身が作成した請求先アカウントのみ見ることができる
- Google Cloud Project と請求先アカウントを紐づけることが出来る Role
  - Billing Account User (roles/billing.user)

[Cloud Billing のアクセス制御と権限](https://cloud.google.com/billing/docs/how-to/billing-access?hl=en)

## 請求される料金

### Cloud Monitoring

```
Cloud Monitoring
https://cloud.google.com/stackdriver/pricing#monitoring-costs

Cloud Monitoring の料金の概要
https://cloud.google.com/stackdriver/pricing#monitoring-pricing-summary
```

## Cloud Billing のアクセス制御と権限

https://cloud.google.com/billing/docs/how-to/billing-access

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

## 参考になる YouTube

### Billing Administration on Google Cloud

[![](https://img.youtube.com/vi/GpiQPym27II/0.jpg)](https://www.youtube.com/watch?v=GpiQPym27II)

