# Cloud Run

## 概要

WIP

## 基本的な動作

WIP

## サンプル


## 注意点

### アドレスについて

起動しているコンテナは `0.0.0.0` で受けて実行できるようにしないといけない。変更不可


https://cloud.google.com/run/docs/reference/container-contract#port


### ポートについて

起動しているコンテナは `8080 ポート` で受けて実行できるようにしないといけない。これは変更可能

```
デフォルトの Port 変更する
gcloud run services update {_run_service_name} --port {_container_port}


https://cloud.google.com/run/docs/configuring/containers?hl=en#configure-port
```
