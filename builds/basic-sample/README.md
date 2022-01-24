# Basic Sample

## 概要

Cloud Build Trigger の基礎的なサンプル

## オプション timeout

+ ビルドステップ毎に timeout を設定出来る
  + https://cloud.google.com/build/docs/build-config-file-schema?hl=en#timeout

```
steps:
- name: 'ubuntu'
  args: ['sleep', '600']
  timeout: 500s
- name: 'ubuntu'
  args: ['echo', 'hello world, after 600s']
```

+ ビルド全体の timeout を設定出来る
  + https://cloud.google.com/build/docs/build-config-file-schema?hl=en#timeout_2
  + デフォルトは 10 分、最大で 24 時間まで設定出来る

```
steps:
- name: 'ubuntu'
  args: ['sleep', '600']
timeout: 660s
```






## 参考

Cloud Build の Step で使用できる公式のコンテナイメージ

https://github.com/GoogleCloudPlatform/cloud-builders
