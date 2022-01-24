# bq

## 概要

```
GCS 専用のコマンド
GCS を操作する時は、このコマンド一択
```

## 準備

+ 以下の環境変数を読み込んでおく

```
export _gcp_pj_id='Your GCP Project ID'
export _dataset_location='asia-northeast1'
export _dataset_name='my_sampele_dataset'
export _table_name='my_sample_table'
```

## データセットの作成

```
bq --project_id ${_gcp_pj_id} --location ${_dataset_location} mk ${_dataset_name}
```

## テーブルの作成

```
bq --project_id ${_gcp_pj_id} \
    mk \
    --table \
    ${_dataset_name}.${_table_name} \
    id:STRING,country:STRING,description:STRING
```

## テーブルの削除

```
bq --project_id ${_gcp_pj_id} rm \
  --table \
  --force \
  ${_gcp_pj_id}:{dataset name}.{table name}
```

## データセットの削除

```
bq --project_id ${_gcp_pj_id} rm \
  dataset_sample
```