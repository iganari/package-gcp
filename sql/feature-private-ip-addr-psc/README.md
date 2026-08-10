# Private on PSC 接続の hogehoge


## 注意する点

**PSC にする場合**

- private_path_for_google(BigQuery 等からのプライベートアクセス許可) が使えない = これは PSA 構成専用の機能なので、PSA なしの PSC 構成では利用できない
- Cloud SQL では、PSC（Private Service Connect）を有効にする場合、パブリック IP（ipv4_enabled = true）は一切利用できません（必ず false にする必要があります）。
