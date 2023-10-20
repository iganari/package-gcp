# Images

## 概要

公式イメージやカスタムイメージについて

## 準備

```
export _gc_pj_id='Your Google Cloud Project ID'
```



## どのような　OS イメージがあるか確認する

+ 基本形

```
gcloud beta compute images list --project ${_gc_pj_id}
```

+ Filter で絞り込む例

```
gcloud compute images list --filter="name~'^rocky-linux-8-optimized-gcp-v.*?'" --format table'(NAME, PROJECT, STATUS)'
```
