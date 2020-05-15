# Alrting

## Terraform による作成方法

公式ドキュメント

+ https://www.terraform.io/docs/providers/google/r/monitoring_alert_policy.html

### id (or name) を知りたい

`terraform import` 等で使いたいが、現状 gcloud コマンドで確認出来ず、GUI の中にも記載が無い

---> URL で確認出来る

+ Monitoring -> Alerting -> Policies の中の調べたい Policy をクリック -> Policy の詳細ページに行く
  + 以下の URL になるはずで、その中に固有の番号がある
  + その番号と project id を組み合わせた文字列が、Alerting の固有 ID

```
### URL がこれだと
https://console.cloud.google.com/monitoring/alerting/policies/15895951981501407518?project=${your GCP project id}

### Alerting の固有 ID はこう
projects/${your GCP project id}/alertPolicies/15895951981501407518
```



+ test.tf

```
resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = "My Alert Policy"
  combiner     = "OR"
  conditions {
    display_name = "test condition"
    condition_threshold {
      filter     = "metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\" AND resource.type=\"gce_instance\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  user_labels = {
    foo = "bar"
  }
}
```

+ 出力結果

```

Apply complete! Resources: 1 added, 3 changed, 0 destroyed.

Outputs:

test = {
  "combiner" = "OR"
  "conditions" = [
    {
      "condition_absent" = []
      "condition_threshold" = [
        {
          "aggregations" = [
            {
              "alignment_period" = "60s"
              "cross_series_reducer" = ""
              "per_series_aligner" = "ALIGN_RATE"
            },
          ]
          "comparison" = "COMPARISON_GT"
          "denominator_aggregations" = []
          "denominator_filter" = ""
          "duration" = "60s"
          "filter" = "metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\" AND resource.type=\"gce_instance\""
          "threshold_value" = 0
          "trigger" = []
        },
      ]
      "display_name" = "test condition"
      "name" = "projects/${your GCP project id}/alertPolicies/15895951981501407518/conditions/15895951981501408523"
    },
  ]
  "creation_record" = [
    {
      "mutate_time" = "2020-05-07T05:18:07.092563292Z"
      "mutated_by" = "hogehoge@example.com"
    },
  ]
  "display_name" = "My Alert Policy"
  "documentation" = []
  "enabled" = true
  "id" = "projects/${your GCP project id}/alertPolicies/15895951981501407518"
  "name" = "projects/${your GCP project id}/alertPolicies/15895951981501407518"
  "project" = "sunkiko-koutei-mng"
  "user_labels" = {
    "foo" = "bar"
  }
}
/
```
