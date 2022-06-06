# Quick Start


## 準備

作業者は以下の 権限 が必要


+ `compute.organizations.enableXpnHost`
  + Compute Shared VPC Admin ( roles/compute.xpnAdmin ) などに入っている


## やること

+ 各 PJ の作成
+ 共有 VPC の有効化
+ サービス プロジェクトをホストプロジェクトに接続する
+ サービス プロジェクトからホストプロジェクトを使えるようにする


## やってみる

host pj にて

```
export _common='sharedvpc-test'

export _sharedvpc_host_id='iganari-sharedvpc-host'
export _sharedvpc_svr_01_id='iganari-sharedvpc-service-01'
export _sharedvpc_svr_02_id='iganari-sharedvpc-service-02'
```

+ ホスト プロジェクトにする必要のあるプロジェクトに対して、共有 VPC を有効にします


```
gcloud beta compute shared-vpc enable ${_sharedvpc_host_id}
```

+ サービス プロジェクトの管理者が共有 VPC を使用するには、サービス プロジェクトがホスト プロジェクトに接続されている必要があります。共有 VPC 管理者は、以下の手順で接続を完了する必要があります。

サービス プロジェクトは 1 つのホスト プロジェクトにのみ接続できますが、ホスト プロジェクトは複数のサービス プロジェクトの接続をサポートしています。詳細については、VPC 割り当てページの共有 VPC に固有の上限をご覧ください。


```
gcloud beta compute shared-vpc associated-projects add ${_sharedvpc_svr_01_id} \
    --host-project ${_sharedvpc_host_id}

gcloud beta compute shared-vpc associated-projects add ${_sharedvpc_svr_02_id} \
    --host-project ${_sharedvpc_host_id}
```

## host でネットワーク作成

+ 環境変数

```
### Env

export _region='asia-northeast1'
export _sub_network_range='172.16.0.0/12'

export _my_ip='Your Home IP Address'
export _other_ip='Your other IP Address'
```


+ VPC Network の作成

```
gcloud beta compute networks create ${_common}-network \
  --subnet-mode=custom \
  --project ${_sharedvpc_host_id}
```

+ サブネットの作成

```
gcloud beta compute networks subnets create ${_common}-subnets \
  --network ${_common}-network \
  --region ${_region} \
  --range ${_sub_network_range} \
  --enable-private-ip-google-access \
  --project ${_sharedvpc_host_id}
```

+ Firewall

```
### 内部通信
gcloud beta compute firewall-rules create ${_common}-allow-internal-all \
  --network ${_common}-network \
  --action ALLOW \
  --rules tcp:0-65535,udp:0-65535,icmp \
  --source-ranges ${_sub_network_range} \
  --target-tags ${_common}-allow-internal-all \
  --project ${_sharedvpc_host_id}

# ### SSH
# gcloud beta compute firewall-rules create ${_common}-allow-ssh \
#   --network ${_common}-network \
#   --action ALLOW \
#   --rules tcp:22,icmp \
#   --source-ranges ${_my_ip},${_other_ip} \
#   --target-tags ${_common}-allow-ssh \
#   --project ${_gcp_pj_id}
```

## hoge

+ 確認

```
gcloud beta compute shared-vpc list-associated-resources ${_sharedvpc_host_id}
```
```
### 例

$ gcloud beta compute shared-vpc list-associated-resources ${_sharedvpc_host_id}
RESOURCE_ID                   RESOURCE_TYPE
iganari-sharedvpc-service-01  PROJECT
iganari-sharedvpc-service-02  PROJECT
```

## サービス プロジェクトからホストプロジェクトを使えるようにする

色々方法がある… 公式ドキュメントを参考

