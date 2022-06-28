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

## オブジェクトのバージョニング ( Object versioning ) 設定する

+ GCS バケット後に設定を On にする

```
gsutil versioning set on -p {PROJECT_ID} gs://BUCKET_NAME
```

+ GCS バケット後に設定を Off にする

```
gsutil versioning set off -p {PROJECT_ID} gs://BUCKET_NAME
```



## rewrite

いろいろ出来るので、やったことがある順に記載していく

+ オブジェクトのストレージクラスの変更 ( https://cloud.google.com/storage/docs/changing-storage-classes#change-object-storage-class )

```
export _storage_class='NEARLINE'  ## STANDARD/NEARLINE/COLDLINE/ARCHIVE

gsutil rewrite -O -s ${_storage_class} gs://{PATH_TO_OBJECT}
```


## iam ch

主に Legacy Roles をコントロールする際に使用する

https://cloud.google.com/storage/docs/gsutil/commands/iam#ch

+ allUser

```
gsutil iam ch allUsers:objectViewer gs://{Your_Bucket_Name}
```

+ 指定

```
gsutil iam ch user:john.doe@example.com:objectCreator gs://ex-bucket

OR

gsutil iam ch user:john.doe@example.com:objectCreator \
              domain:www.my-domain.org:objectViewer \
              group:readers@example.com:legacyBucketReader \
              serviceaccounts:hogehoge-sa@appspot.gserviceaccount.com \
              gs://ex-bucket
```
