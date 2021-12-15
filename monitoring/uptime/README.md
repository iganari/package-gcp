# uptime check

## WIP

WIP

## Tips

### ID について

+ 作成時に指定するのは `display name`
+ 識別子である `id` は自動に作られ、以下のような法則性がある
  + https://cloud.google.com/monitoring/uptime-checks?hl=en#uptime-check-ids

```
projects/[PROJECT_ID]/uptimeCheckConfigs/[UPTIME_CHECK_ID]
```

現状だと、この `id` を gcloud コマンドで探すことは出来ない ??

Terraform で import などをする際に `id` が必要になるので注意

+ google_monitoring_uptime_check_config / Import
  + https://www.terraform.io/docs/providers/google/r/monitoring_uptime_check_config.html#import

## Uptime Check の時の拠点の IP アドレス

いくつかの手法で IP アドレスのレンジを取得できる

[Reviewing uptime checks | Getting uptime-check IP addresses](https://cloud.google.com/monitoring/uptime-checks/using-uptime-checks#get-ips)

Cloud Console の Monitoring の Uptime Check のページから TEXT の形式で取得できる
