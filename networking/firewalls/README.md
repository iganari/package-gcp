# Firewall


## `ロードバランサ` の上り（内向き）

+ 内部 TCP / UDP 負荷分散（ヘルスチェック）
+ 内部 HTTP(S) 負荷分散（ヘルスチェック）
+ TCP プロキシ負荷分散（ヘルスチェック）
+ SSL プロキシ負荷分散（ヘルスチェック）

```
35.191.0.0/16
130.211.0.0/22
```

## `ネットワーク負荷分散` の上り（内向き）

```
35.191.0.0/16
209.85.152.0/22
209.85.204.0/22
```

## 参考

+ https://cloud.google.com/load-balancing/docs/health-checks?hl=ja
+ https://cloud.google.com/load-balancing/docs/health-check-concepts?hl=ja#ip-ranges
