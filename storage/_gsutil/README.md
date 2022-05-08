# gsutil

## 概要

```
GCS 専用のコマンド
GCS を操作する時は、このコマンド一択
```

## 使い方

+ [mb](./README.md#mb): GCS のバケットの作成

## mb

GCS のバケットの作成

+ 基本

```
gsutil mb gs://BUCKET_NAME
```

+ 色々、指定する場合
  + -p: バケットが関連するプロジェクトを指定します。例: `my-project`
  + -c: バケットのデフォルトのストレージ クラスを指定します。
    + `STANDARD` , `NEARLINE` , `COLDLINE` , `ARCHIVE`
    + https://cloud.google.com/storage/docs/storage-classes#classes
  + -l: バケットのロケーションを指定します。
    + 例: `US-EAST1`

```
gsutil mb -p {PROJECT_ID} -c {STORAGE_CLASS} -l {BUCKET_LOCATION} gs://BUCKET_NAME
```

## rm

+ バケットの削除

```
gsutil rm -r gs://bucket
```


## rewrite

いろいろ出来るので、やったことがある順に記載していく

+ オブジェクトのストレージクラスの変更 ( https://cloud.google.com/storage/docs/changing-storage-classes#change-object-storage-class )

```
export _storage_class='NEARLINE'  ## STANDARD/NEARLINE/COLDLINE/ARCHIVE

gsutil rewrite -O -s ${_storage_class} gs://{PATH_TO_OBJECT}
```
