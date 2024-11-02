# gcloud コマンドのサンプル

## 使い方

- Cloud Monitoring API の有効化
  - https://cloud.google.com/monitoring/api/enable-api?hl=en#gcloud-cli

```
gcloud beta services enable monitoring --project {Your Google Cloud Project ID}
```

- Python の仮想環境を作成

```
python3 -m venv .gcloud_moni_sample
source .get-monitoring-metrics-value/bin/activate
```

- パッケージをインストール

```
pip3 install -r requirements.txt
```

- Google Cloud と認証する

```
gcloud auth application-default login --no-launch-browser
```

- Cloud SQL のメトリクスを取得する
  - 1 分単位で、直近 5 分のメトリクスを取得

```
### CPU
python3 sql-cpu.py


### Memory
python3 sql-memory.py
```

- Memorystore for Redis のメトリクスを取得する
  - 1 分単位で、直近 5 分のメトリクスを取得

```
### CPU
python3 memorystore-redis-cpu.py


### Memory
python3 memorystore-redis-memory.py
```






