# gcloud の覚書

+ [auth](./README.md#auth)
+ [configurations](./README.md#configurations)
+ [IAM](./README.md#iam)
+ [monitoring](./README.md#monitoring)
+ [update](./README.md#update)
+ [services](./README.md#services)

## 準備

```
export _gcp_pj_id="Your GCP Project ID"
```

## auth

+ 公式ドキュメント
    + https://cloud.google.com/sdk/gcloud/reference/auth/

認証について

+ gcloud auth コマンドにて GCP との認証を行えます。
+ Web ブラウザが必要になるので、その環境を用意して下さい。

+ そのターミナル上で GCP を操作する場合
    + ブラウザの認証が必要

```
gcloud auth login
```
 
+ SDK や Terraform のようなプログラムを介して、 GCP を操作する場合
    + ブラウザの認証が必要

```
gcloud auth application-default login
```

+ Service Account に紐づくキーを用いて認証を行う場合
    + ブラウザの認証が不要になる
    + https://cloud.google.com/sdk/gcloud/reference/auth/activate-service-account?hl=en

```
gcloud auth activate-service-account test-service-account@google.com \
    --key-file=/path/key.json \
    --project=testproject
```

+ ローカルに保持している auth の情報の確認

```
gcloud auth list
```

+ アクティブなユーザのみ表示する

```
gcloud auth list --filter=status:ACTIVE --format="value(account)"
```

## configurations

+ gcloud コマンドを使う際の設定
+ 環境ごとに設定を分けて、それを切り替えて使うことが可能
+ どんな名前でもいいが、GCP プロジェクトと紐付けると見分けやすい

### 基本的な使い方

+ config の作成

```
gcloud config configurations create ${Config Name}
```

+ config リストの確認

```
gcloud config configurations list
```

### 使い方例

```
### ex
_my_project_name='iganari-test-2020'

gcloud config configurations create ${_my_project_name}
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a
gcloud config set project ${_my_project_name}

# gcloud config configurations list
NAME                 IS_ACTIVE  ACCOUNT                     PROJECT              DEFAULT_ZONE       DEFAULT_REGION
iganari-test-2020    True       hogehoge@example.com        iganari-test-2020    us-central1-a      us-central1
```

## IAM

+ IAM の `Permissions` を確認する

```
gcloud projects get-iam-policy ${GCP Project ID}
```
```
### 例

# gcloud projects get-iam-policy ${GCP Project ID}
bindings:
- members:
  - serviceAccount:service-9999999999@compute-system.iam.gserviceaccount.com
  role: roles/compute.serviceAgent
- members:
  - serviceAccount:9999999999-compute@developer.gserviceaccount.com
  - serviceAccount:9999999999@cloudservices.gserviceaccount.com
  - serviceAccount:mogumogu@iganari-pkg-gcp.iam.gserviceaccount.com
  role: roles/editor
- members:
  - serviceAccount:hogehoge@iganari-pkg-gcp.iam.gserviceaccount.com
  - serviceAccount:fugafuga@iganari-pkg-gcp.iam.gserviceaccount.com
  role: roles/iam.securityAdmin
version: 1
```


+ IAM の Service Account をリストを表示する

```
gcloud iam service-accounts list --project ${GCP Project ID}
```

+ role を付与する

```
gcloud projects add-iam-policy-binding ${GCP Project ID} --member={account} --role={role}
```
```
### 例

gcloud projects add-iam-policy-binding ${GCP Project ID} --member={account} --role={role}
```


## monitoring

:warning: WIP

Cloud Monitoring 用のコマンド

```
export _pj_id='Your GCP Project Id'
```

```
gcloud alpha monitoring channel-descriptors describe projects/${_pj_id}/notificationChannelDescriptors/slack
```

## update

gcloud コマンド自体のアップデートを行う

```
gcloud --quiet components update
gcloud --quiet components install beta
```
```
gcloud --quiet components install kubectl
```


## services

+ 公式ドキュメント
    + https://cloud.google.com/sdk/gcloud/reference/services

+ すべてのリストを表示

```
gcloud beta services list --project ${_gcp_pj_id}
```

+ 有効化しているリストを表示

```
gcloud beta services list --enabled --project ${_gcp_pj_id}
```

+ サービスを有効化する

```
gcloud beta services enable {Services Name} --project ${_gcp_pj_id}
```

+ サービスを無効化する

```
gcloud beta services disable {Services Name} --project ${_gcp_pj_id}
```
