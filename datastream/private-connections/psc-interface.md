:memo: AI-powered documentation

Datastream (Project B) から、別プロジェクト (Project A) の Network Attachment へ、手動承諾 (`ACCEPT_MANUAL`) で PSC (Private Service Connect) 接続を構築する手順書です。

この構成では、**「Datastream が裏で使用する Google 管理のテナントプロジェクト」の ID を特定し、Project A 側で許可リストに追加する**というステップが重要になります。

---

### 前提条件と環境

* **Project A (`project-a`)**: VPC が存在し、Network Attachment を作成するプロジェクト。
* **Project B (`project-b`)**: Datastream を配置し、Private Connection を作成するプロジェクト。
* **リージョン**: `asia-northeast1` (両プロジェクトで一致させます)

---

### Step 1: 【Project A】 Network Attachment の作成 (Terraform)

まず、Project A にて PSC 用のサブネットと Network Attachment を作成します。
この時点ではテナントプロジェクトの ID が不明なため、`producer_accept_lists` は一旦空（または自プロジェクトのみ）で作成します。

```hcl
# 1. PSC用のサブネット (purpose が PRIVATE_SERVICE_CONNECT である必要があります)
resource "google_compute_subnetwork" "psc_subnet" {
  project       = "project-a" # Project A
  name          = "my-psc-subnet"
  region        = "asia-northeast1"
  network       = "projects/project-a/global/networks/my-vpc-network"
  ip_cidr_range = "10.0.0.0/24"
  purpose       = "PRIVATE_SERVICE_CONNECT"
}

# 2. Network Attachment (手動承諾)
resource "google_compute_network_attachment" "main" {
  project               = "project-a" # Project A
  name                  = "my-network-attachment"
  region                = "asia-northeast1"
  connection_preference = "ACCEPT_MANUAL"
  subnetworks           = [google_compute_subnetwork.psc_subnet.id]

  # この時点では空にしておくか、Datastreamのプロジェクトを入れておきます
  producer_accept_lists = [] 
}

```

👉 **作業:** 上記のコードを `terraform apply` して、Network Attachment を作成します。

---

### Step 2: 【Project B】 Datastream テナントプロジェクト ID の取得 (gcloud)

Project B で Datastream Private Connection の作成を試行し、エラーメッセージまたはドライラン出力から**テナントプロジェクトの ID** を取得します。

ターミナルから以下の `gcloud` コマンドを実行します。
※ `--validate-only` を付けることで、実際には作成せず検証のみ行います。

```bash
gcloud datastream private-connections create my-private-conn \
  --project=project-b \
  --location=asia-northeast1 \
  --display-name="my-private-conn" \
  --network-attachment="projects/project-a/regions/asia-northeast1/networkAttachments/my-network-attachment" \
  --validate-only

```

**【取得のポイント】**
コマンドの実行結果（または検証に失敗した際のエラーメッセージ）の中に、以下のような ID が含まれます。

* `p123456789-tp` （小文字のp + 数字 + -tp の形式）
* またはテナントプロジェクトの番号そのまま（例: `123456789012`）

*※注意: `--validate-only` でうまく ID が出力されない場合は、`--validate-only` を外して実行し、意図的に「アクセス拒否」のエラーを発生させることで、エラーログ（Cloud Logging等）からテナントプロジェクト ID を拾うことができます。*

---

### Step 3: 【Project A】 Network Attachment にテナントプロジェクトを許可 (Terraform)

Step 2 で取得したテナントプロジェクト ID を、Project A の `producer_accept_lists` に追加し、Terraform で更新します。

```hcl
resource "google_compute_network_attachment" "main" {
  project               = "project-a"
  name                  = "my-network-attachment"
  region                = "asia-northeast1"
  connection_preference = "ACCEPT_MANUAL"
  subnetworks           = [google_compute_subnetwork.psc_subnet.id]

  producer_accept_lists = [
    "p123456789-tp", # Step 2 で取得した Datastream のテナントプロジェクト ID
    "project-b"      # (オプション) Project B 自身の ID を念のため入れても良いです
  ]
}

```

👉 **作業:** Project A 側で再度 `terraform apply` を実行し、承認リストを更新します。

---

### Step 4: 【Project B】 Datastream Private Connection の作成 (Terraform)

承諾リストの更新が完了したら、いよいよ Project B 側で Terraform を使って Private Connection を作成します。

```hcl
resource "google_datastream_private_connection" "main" {
  project               = "project-b" # Project B
  private_connection_id = "my-private-conn"
  display_name          = "my-private-conn"
  location              = "asia-northeast1"

  psc_interface_config {
    # Project A の Network Attachment のフルパスを指定
    network_attachment = "projects/project-a/regions/asia-northeast1/networkAttachments/my-network-attachment"
  }

  timeouts {
    create = "60m"
  }
}

```

👉 **作業:** Project B 側で `terraform apply` を実行します。

今度は、Project A の Network Attachment 側で Datastream テナントプロジェクトからの接続要求が明示的に許可されているため、「An unknown error occurred」が発生することなく、正常に Private Connection が `CREATED` 状態になります。

### 補足と注意点

* **Terraform プロバイダについて**: Project A と Project B でリソースを作成するため、1つの Terraform コードで管理する場合は `provider` をエイリアス (`alias`) で分けるか、リソースブロック内で `project = "..."` を明示的に指定して、適用先プロジェクトを間違えないように注意してください。
* Private Connection の作成は非常に時間がかかる場合があるため（15分〜30分程度）、`timeouts` ブロックで十分な時間を設定しておくことを推奨します。
