# kind: ManagedCertificate

## ドキュメント

+ Google マネージド SSL 証明書の使用
  + https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs?hl=ja

## API バージョン

Google が管理する SSL 証明書は ManagedCertificate カスタム リソースを使用して構成します。このカスタム リソースは GKE クラスタのバージョンに応じて以下の異なる API バージョンで使用できます。

+ ManagedCertificate v1beta2 API は、GKE クラスタ バージョン 1.15 以降で使用できます。
+ ManagedCertificate v1 API は、GKE クラスタ バージョン 1.17.9-gke.6300 以降で使用できます。

GKE クラスタは現在 ManagedCertificate v1beta1 API をサポートしていますが、この API バージョンは非推奨で、今後の GKE バージョンで削除される予定です。新しい API バージョンの使用をおすすめします。
