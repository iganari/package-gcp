# Basic

## 概要

VPC Network, Subnet などを作る基本的なコマンド

## 実際作っている

- 環境変数を設定する

```
export _gc_pj_id='Your Google Cloud Project ID'
export _common='pkg-gcp'
```

- VPC Network の作成
  - Subnet はこの時に自動で作られない様にする = **--subnet-mode custo**

```
gcloud beta compute networks create ${_common} \
  --subnet-mode custom \
  --project ${_gc_pj_id}
```
