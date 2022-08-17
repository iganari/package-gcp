# Cloud Armor

## 概要

Google Cloud のマネージドの Web Application Firewall ( WAF )

2021/11 の時点では 2 種類存在している

+ Google Cloud Armor
  + DDoS 攻撃からの保護を標準装備
  + クロスサイトスクリプティング ( XSS ) や、 SQL インジェクション ( SQLi ) などのアプリケーション攻撃からの保護
    + OWASP ModSecurity Core Rule Set (CRS) のルールに則った防御ルールの作成が可能
    + ASN( Autonomous System number ) も可
  + reCAPTCHA Enterprise を簡単に実装可能


```
Google Cloud Armor overview
https://cloud.google.com/armor/docs/cloud-armor-overview
```


## Price

https://cloud.google.com/armor/pricing

## GKE Cluster 上で Cloud Armor を使用する

[Cloud Armor を試す](../../kubernetes/feature-cloud-armor)

## memo

参考 URL

```
https://cloud.google.com/armor/docs/rule-tuning?hl=ja#sql_injection_sqli
https://coreruleset.org/
https://cloud.google.com/armor/docs/security-policy-overview?hl=ja
```

+ Google Cloud Armor WAF ルールのチューニング
  + https://cloud.google.com/armor/docs/rule-tuning
+ OWASP ModSecurity Core Rule Set (CRS)
  + https://github.com/coreruleset/coreruleset/tree/v3.0/master
+ カスタムルールを作りたい時
  + https://cloud.google.com/armor/docs/rules-language-reference?hl=ja
+ reCAPTCHA Enterprise
  + https://cloud.google.com/recaptcha-enterprise/docs/overview
