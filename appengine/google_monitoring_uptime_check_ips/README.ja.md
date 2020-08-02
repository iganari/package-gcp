# google_monitoring_uptime_check_ips

## 概要

Terraform にて、 Cloud Monitoring の監視拠点の IP アドレスを動的に取れるようになったので使い方をまとめる

## リンク

[App Engine の場合](./README.ja.md)

[Compute Engine の場合]

## Terraform の公式 URL

https://www.terraform.io/docs/providers/google/d/datasource_google_monitoring_uptime_check_ips.html

## 説明

+ IP アドレスのデータは JSON の形式で取得出来る
+ App Engine の Firewall Rules に設定できる
+ しかし、Firewall Rules の Priority を後から編集することが出来ないため、Priority が変更しないように設定しないといけない

## Terraform 実行方法

WIP

