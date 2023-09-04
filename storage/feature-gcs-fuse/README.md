# Cloud Storage FUSE

## 公式ドキュメント

https://cloud.google.com/storage/docs/gcs-fuse

## 注意点

使ってみての注意点

1. サーバの再起動をすると gcsfuse 外れる
1. gcsfuse を実行したユーザ以外からはマウントしたディレクトリが見れない( Permission を適切に設定しても... )
1. gcsfuse 実行時にフォルダとファイルのパーミッションを一律に設定する
1.
1.


```
gcsfuse --dir-mode 0755 --file-mode 0755  --uid 1002 -gid 1003 --only-dir {{ path of Cloud Storage Buckets }} {{ Cloud Storage Buckets }} {{ local folder path }}
```
