# Memorystore for Redis

## 概要

TBD

## API の有効化

```
export _gc_pj_id='Your Google Cloud Project ID'

gcloud beta services enable redis.googleapis.com --project ${_gc_pj_id}
```

## 参考資料

+ Memorystore for Redis のパフォーマンスを調整する際のベスト プラクティス
  + https://cloud.google.com/blog/ja/products/databases/performance-tuning-best-practices-for-memorystore-for-redis

+ Memorystore とは
  + https://cloud.google.com/blog/ja/topics/developers-practitioners/what-memorystore

+ Memorystore for Redis の SLA
  + https://cloud.google.com/memorystore/sla-20200109

+ インスタンス スケーリング時の動作
  + https://cloud.google.com/memorystore/docs/redis/scaling-behavior

+ Redis インスタンスのスケーリング
  + https://cloud.google.com/memorystore/docs/redis/scaling-instances

