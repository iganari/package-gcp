# Parallel Step


並列実行の書き方


https://cloud.google.com/build/docs/configuring-builds/configure-build-step-order

## デフォルト

+ 上から順に実行される

```
steps:
- name: foo
- name: bar
```

