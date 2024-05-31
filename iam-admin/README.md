# IAM & Admin

+ Google Cloud との認証の仕方

## gcloud command-line tool を用いた認証方法

```
gcloud auth login
OR
gcloud auth login --no-launch-browser
```

## Service Accounts を用いた認証方法

```
WIP
```

## Tipe

[Google Cloud の組織全体を見渡したい時に持っておくと良い Role 一覧](../cloud-resource-manager/README.md)

## Gooogle Cloud Project の Project Number を調べるコマンド

- Project の情報を表示する

```
gcloud beta projects describe ${_gc_pj_id}
OR
gcloud beta projects describe ${_gc_pj_id} --format json
```

- Project Number だけを出す

```
gcloud beta projects describe ${_gc_pj_id} --format="value(projectNumber)"
OR
gcloud beta projects describe ${_gc_pj_id} --format json | jq -r .projectNumber
```
