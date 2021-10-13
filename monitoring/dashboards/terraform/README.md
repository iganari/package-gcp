# Dashboards by Terraform


## Terraform で管理する場合

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_dashboard

### Terraform で使うコード

+ dashboards.tf

```
resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = file("dashboards.json")
}
```

+ dashboards.json

```
{
  "displayName": "Demo Dashboard",
  "gridLayout": {
    "widgets": [
      {
        "blank": {}
      }
    ]
  }
}
```

### JSON の作りかた

+ 下記の API を使えば、既存のダッシュボードを JSON で吐き出すことが出来る
  + https://cloud.google.com/monitoring/api/ref_v3/rest/v1/projects.dashboards/get
  + 故に、ある程度手動で作成し、JSON を吐き出して管理すればいい
