# Quotas | 割り当て


## 公式

https://cloud.google.com/load-balancing/docs/quotas

## よく聞く問題

+ 上限を引き上げることが出来ない値

```
1 つの Ingress に path が 50 個までしかぶら下げられない
---> URL マップごとのホストルール数 が 50 個までであり、上限変更できない
```