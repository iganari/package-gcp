# Private on PSC 接続の hogehoge


## 注意する点

**PSC にする場合**

- private_path_for_google(BigQuery 等からのプライベートアクセス許可) が使えない = これは PSA 構成専用の機能なので、PSA なしの PSC 構成では利用できない
- Cloud SQL では、PSC（Private Service Connect）を有効にする場合、パブリック IP（ipv4_enabled = true）は一切利用できません（必ず false にする必要があります）。
- Cloud SQL の停止を行うと `psc_service_attachment_link` が変更される可能性がある。これ自体は良いのだけど、これは Forwarding Rule で target として使っている。Forwarding Rule の target が変更が不可能なリソースのため、結果として Cloud SQL の停止をする(例えば、コストカットのために夜間停止をする場合など)場合は、起動・停止じに Forwarding Rule の作り直しも実装する必要がある
  - IP アドレス等は 変わらないので問題無し
  - Terraform でインフラリソースなどを管理している場合は要注意
- 共有 VPC を使っている場合で、PSC は PSC 同士しか使わない場合(かなりニッチ)は、以下の構成が可能であり、ロジェクト側」 で転送ルールを作成することが多いです。
  - PSA -> 共有 VPC のホストプロジェクトのネットワーク
  - PSC -> 共有 PVC のサービスプロジェクトのネットワーク
  - ※ 一般的に共有 VPC 環境で PSC を構成する場合、権限と管理の分離の観点から 「サービスプロジェクト側」 で転送ルールを作成することが多いです。
