# Serverless VPC access

## 公式ドキュメント

```
Serverless VPC Access | Overview 
https://cloud.google.com/vpc/docs/serverless-vpc-access
```

## 注意点

1. 一度作成すると変更は基本的に出来ない
1. コネクタの中で作成するインスタンスの数は min/max ともに 2 ~ 10 しか設定出来ない && 作成後は `自動でスケールアウトするが、スケールインは自動・手動問わず出来ない` = インスタンスが 1 度増えたら、減らす手段は無い

上記の理由につき、コネクタをなにかしら変更をしたい場合は再作成し付け替えるしか手段が無い(2021/12 現在)
