# IAP to Cloud SQL

## 概要

IAP 越しに パブリック IP アドレスが無い Cloud SQL に パブリック IP アドレスが無い GCE を通じてログインします

+ [Cloud SQL for MySQL 編](./mysql/README.md)

![](./img/iap-to-cloudsql.png)

GCE から Cloud SQL へは VPC Network Reering を使って疎通している図

![](https://cloud.google.com/sql/images/private-ip.svg)
