# BigQuery

## 説明

```
サーバーレス データ ウェアハウス
```

### 用語簡易説明

+ Dataset
  + 後述の Table を管理する単位
  + プロジェクト内に複数作成可能
  + Google Cloud プロジェクト:Dataset = 1:N
+ Table
  + 実際のデータ(レコード)が入っている単位
  + 同一の Google Cloud プロジェクト内に 複数作成可能
  + Dataset:Table = 1:N




## [サンプルクエリ](./sample_query/README.md)

+ 任意の時間のデータを抽出して永続化させたい
+ 時間のイメージなくバックアップを取りたい

## [Import BQ From Amazon S3](./import-bq-from-amazons3)

WIP

## [Import BQ From GCS](./import-bq-from-gcs)

GCS -> BQ

## [Import BQ From Google Ads](./import-bq-from-googleads)

WIP

## [QuickStart CLI](./quickstart-cli)

クイックスタート

## Tips

BigQuery向けのSQL の構文解析ツール -> [tree-sitter for BigQuery's SQL](https://github.com/TKNGUE/tree-sitter-sql-bigquery)

+ 他のサイト( いつか自分でもやってみるリスト )
  + [BigQueryで高額課金が発生しているクエリの呼び出し元を特定する](https://ex-ture.com/blog/2023/08/13/bigqueryで高額課金が発生しているクエリの呼び出し元/)


## 注意点

+ [データセットに名前を付ける](https://cloud.google.com/bigquery/docs/datasets?hl=en)
  + 1,024 文字まで。
  + 文字 (大文字または小文字) 、数字、アンダースコア。
  + スペースや特殊文字 (`-`, `&`, `@`, `%` など) を含めることは出来ない



