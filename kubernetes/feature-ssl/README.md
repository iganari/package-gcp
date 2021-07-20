# SSL 証明書を設定する

## 概要

[SSL certificates overview](https://cloud.google.com/load-balancing/docs/ssl-certificates)

+ 以下の証明書が使用できる
  + [Google が取得して管理する Google マネージド証明書](./README.md#google-マネージド-ssl-証明書を使う)
  + [独自のセルフマネージド証明書](./README.md#セルフマネージド-ssl-証明書を使う)

## Google マネージド SSL 証明書を使う

+ 公式ドキュメント
  + https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs?hl=ja

+ メリット
  + Google マネージド SSL 証明書は、ドメイン用に Google Cloud が取得して管理する証明書で、自動的に更新される
+ デメリット
  + Google マネージド証明書はドメイン認証（DV）証明書です。
  + 証明書に関連付けられた組織や個人の ID を証明せず、ワイルドカードの共通名をサポートしません。(複数設定は可能です)

実際に使ってみる ---> [package-gcp | kind: ManagedCertificate](../kind-managedcertificate)

## セルフマネージド SSL 証明書を使う

https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs?hl=ja

実際に使ってみる ---> WIP
