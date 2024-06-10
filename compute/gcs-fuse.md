# Cloud Storage FUSE について

## 概要

Compute Engine や Cloud Run から Cloud Storage をあたかもファイルサーバとしてマウントが出来る (Cloud Storage はオブジェクトストレージ)

- 概要
  - https://cloud.google.com/storage/docs/gcs-fuse
- インストール方法
  - https://cloud.google.com/storage/docs/gcsfuse-install
- GCE からマウントする方法
  - https://cloud.google.com/storage/docs/gcsfuse-mount


## やってみる

```
export _gc_pj_id='Your Google Cloud Project ID'
```

### Cloud Storage の作業

- Cloud Storage Buckets の作成

```
gcloud storage buckets create gs://${_gc_pj_id}-fuse-gce \
  --location asia-northeast1 \
  --uniform-bucket-level-access \
  --project ${_gc_pj_id}
```

### Compute Engine

:warning: ROOT 以外で実施すること

- Cloud Storage FUSE のパッケージを登録

```
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb [signed-by=/usr/share/keyrings/cloud.google.asc] https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
```

- Import the Google Cloud public key:

```
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.asc
```

- Cloud Storage FUSE を apt 経由でインストール

```
sudo apt-get update
sudo apt-get install -y gcsfuse
```

- 確認

```
gcsfuse --version
```
```
### 例

$ gcsfuse --version
gcsfuse version 2.2.0 (Go version go1.22.3)
```

- Cloud Storage をマウントする、サーバ側のディレクトリの作成

```
sudo mkdir -p /mnt/gcsfuse
sudo chown `whoami`:`whoami` -R /mnt/gcsfuse
```

- gcsfuse コマンドを用いて、 Cloud Storage をマウントする
  - :warning: `gs://` は **いらない**

```
### gs:// は不要

gcsfuse `curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google"`-fuse-gce /mnt/gcsfuse
```

- GCE の中から書き込みが出来るか確認

```
touch /mnt/gcsfuse/test-fuse-from-`hostname`
```

- Cloud Storage から、先ほどのテストファイルを確認

```
gcloud storage ls gs://`curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google"`-fuse-gce/
```
```
### 例

$ gcloud storage ls gs://`curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google"`-fuse-gce/
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    26  100    26    0     0   4070      0 --:--:-- --:--:-- --:--:--  4333

gs://hogehoge-fuse-gce/fugafuga-gce
```

---> これでマウント出来ました

- gce の再起動をしてもちゃんとマウントされているか確認をする
  - TBD
