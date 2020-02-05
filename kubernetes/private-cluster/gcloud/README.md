# gcloud コマンドを用いて、限定公開クラスタを構築する

## やること

+ hogehoge

## 構築作業

### gcloud コマンドの用意する

+ Docker コンテナを起動する ---> :whale:

```
sh docker-build-run.sh
```

+ :whale: gcloud コマンドのアップデート

```
gcloud components update
gcloud components install beta
```

+ :whale: gcloud の設定を先にいれます。

```
### ここはよしなに変更して下さい

export _pj='{Your GCP Project ID}'
export _common='igrs-priv-cls'
export _region='us-central1'
```

```
gcloud config configurations create ${_pj}

gcloud config set compute/region ${_region}
gcloud config set compute/zone us-central1-a
gcloud config set project ${_pj}
```

+ :whale: gcloud の設定を確認します。

```
gcloud config configurations list
```

+ :whale: GCP と認証をします。
  + Web ブラウザ経由で認証をします。

```
gcloud auth login
```


+ :whale: VPC ネットワークを作成します。

```
gcloud beta compute networks create ${_common}-nw \
  --subnet-mode=custom
```

+ :whale: サブネットワークを作成します。
  + WIP

```
gcloud beta compute networks subnets create ${_common}-sb \
  --network ${_common}-nw \
  --region ${_region} \
  --range 192.168.0.0/20 \
  --secondary-range pods-range=10.4.0.0/14,services-range=10.0.32.0/20 \
  --enable-private-ip-google-access
```

+ :whale: Private Cluster (リージョナル) を構築します。

```
gcloud beta container clusters create ${_common}-cls \
  --region ${_region} \
  --enable-master-authorized-networks \
  --network ${_common}-nw \
  --subnetwork ${_common}-sb \
  --cluster-secondary-range-name pods-range \
  --services-secondary-range-name services-range \
  --enable-private-nodes \
  --enable-ip-alias \
  --master-ipv4-cidr 172.16.0.16/28 \
  --no-enable-basic-auth \
  --no-issue-client-certificate
  --num-nodes=1 \
  --release-channel stable \
  --preemptible
```

+ :whale: マスター承認ネットワークを設定します。

```
gcloud container clusters update ${_common}-cls \
    --region ${_region} \
    --enable-master-authorized-networks \
    --master-authorized-networks [EXISTING_AUTH_NETS],[SHELL_IP]/32
```

+ :whale: GKE と承認をします。

```
gcloud container clusters get-credentials ${_common}-cls \
    --region ${_region} \
    --project ${_pj}
```


+ :whale:



+ :whale:













