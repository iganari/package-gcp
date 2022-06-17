# Cloud IDS

## 概要

Cloud IDSとはGCPが提供しているフルマネージドな IDS (Intrusion Detection System) であり、日本語だと `侵入検知システム` です。

VPC ネットワーク内の通信を監視し、セキュリティリスクを発見してくれます。

IDS そのものは Palo Alto のものが使われており、検知可能なシグネチャは Palo Alto のページで確認できます。

```
Palo Alto Networks Brings Network Threat Detection to Google Cloud
https://www.paloaltonetworks.com/blog/2021/07/google-cloud-network-threat-detection/
```

### YouTube

[![](https://img.youtube.com/vi/8p_zZIi0hQk/0.jpg)](https://www.youtube.com/watch?v=8p_zZIi0hQk)

### 公式ブログ

+ [Google の信頼できるクラウドの拡張: Cloud IDS の導入でネットワークベースの脅威を検出](https://cloud.google.com/blog/ja/products/identity-security/detect-complex-network-threats-with-cloud-ids)
+ [高度なネットワーク脅威検出に Cloud IDS を最大限活用](https://cloud.google.com/blog/ja/products/identity-security/how-google-cloud-ids-helps-detect-advanced-network-threats)
+ [ネットワークベースの脅威を検出する Google Cloud IDS の一般提供を開始](https://cloud.google.com/blog/ja/products/identity-security/announcing-general-availability-of-google-cloud-ids)
+ [Google Cloud IDS のシグネチャの更新による Apache Log4j の脆弱性 CVE-2021-44228、CVE-2021-45046、CVE-2021-4104、CVE-2021-45105、CVE-2021-44832 の検出](https://cloud.google.com/blog/ja/products/identity-security/cloud-ids-to-help-detect-cve-2021-44228-apache-log4j-vulnerability)

### Web コンソール

![](./img/01.png)

![](./img/02.png)

## 出来ること・出来ないこと

IDS なので `検知` するまで。防止は出来ない。防止をしたい場合は他のソリューションを考える

## やってみた

[Quick Start](./quick-start/)

一連の流れを確認

## OSS の IDS

Cloud IDS の導入が難しい場合は OSS の IDS の導入を検討する必要がある

+ OSS の IDS
  + Suricata
  + Snort
