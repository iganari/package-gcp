# Tips: Windows Server on GCE を構築する

+ :warning: この情報は 2020/03/11 に書きました。

## 手段

+ カスタムイメージを使うことで Windows Server を構築出来ます。
  + Server ですが、GUI があるため Desktop ライクに使えます :)
+ 最初だけ IE のセキュリティの問題があり注意が必要です。
  + 後述します。

## Windows Server を GCE 上に構築する

### 準備

+ GCP との認証をします。

```
gcloud auth login
```

+ 設定を変数に入れておきます、

```
export _region='asia-northeast1'
export _zone='asia-northeast1-a'
export _common='win-on-gce-test'
```

### ネットワークの作成

+ VPC ネットワークの作成します。

```
gcloud beta compute networks create ${_common}-network \
    --subnet-mode=custom
```

+ サブネットの作成します。

```
gcloud beta compute networks subnets create ${_common}-subnet \
    --network ${_common}-network \
    --region ${_region} \
    --range 172.16.0.0/12
```

### Firewall Rule の作成

+ RDP 用の Firewall Rules を作成します。
  + テスト的に `0.0.0.0/0` を許可していますが、本来なら `{IPアドレス}/32` というように絞るべきです。

```
gcloud beta compute firewall-rules create ${_common}-allow-rdp \
    --network ${_common}-network \
    --allow tcp:3389,icmp \
    --source-ranges 0.0.0.0/0
```

### GCE の作成

+ 以下の点に注意して作成します。
  + Boot disk は特定のイメージを使います。
  + Firewall Rules は先に作成した RDP 用のを用います。 

```
gcloud beta compute instances create ${_common} \
    --zone=${_zone} \
    --machine-type=n1-standard-1 \
    --subnet=${_common}-subnet \
    --maintenance-policy=MIGRATE \
    --tags=${_common}-allow-rdp \
    --image=windows-server-2019-dc-v20200211 \
    --image-project=gce-uefi-images \
    --boot-disk-size=50GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=${_common}-disk \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --reservation-affinity=any
```
```
### ex

# gcloud beta compute instances create ${_common} \
>     --zone=${_zone} \
>     --machine-type=n1-standard-1 \
>     --subnet=${_common}-subnet \
>     --maintenance-policy=MIGRATE \
>     --tags=${_common}-allow-rdp \
>     --image=windows-server-2019-dc-v20200211 \
>     --image-project=gce-uefi-images \
>     --boot-disk-size=50GB \
>     --boot-disk-type=pd-standard \
>     --boot-disk-device-name=${_common}-disk \
>     --no-shielded-secure-boot \
>     --shielded-vtpm \
>     --shielded-integrity-monitoring \
>     --reservation-affinity=any
WARNING: You have selected a disk size of under [200GB]. This may result in poor I/O performance. For more information, see: https://developers.google.com/compute/docs/disks#performance.

NAME             ZONE               MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP    STATUS
win-on-gce-test  asia-northeast1-a  n1-standard-1               172.16.0.2   34.84.176.202  RUNNING
```

### :warning: GUI で作る時の注意点

+ Boot disk のところで `Show images with Shielded VM features` にチェックを入れます。

![](./images/compute_win-vm-01.png)

+ `Datacenter Core 以外` が出てくるので、それを選択します。
  + 今回は `Windows Server 2019 Datacenter` を選択します。

![](./images/compute_win-vm-02.png)

### RDP 接続用のユーザとパスワードを作成

+ gcloud コマンドで作成した VM が出来ているのが確認出来るので、RDP 用のパスワードをコンソールから作成します。

![](./images/compute_win-vm-03.png)

+ `Set Windows password` をクリックします。

![](./images/compute_win-vm-04.png)

+ RDP 用のユーザ名を入力します。

![](./images/compute_win-vm-05.png)

+ しばらくすると、自動生成されたパスワードが表示されるのでこれを控えておきます。

![](./images/compute_win-vm-06.png)

## 実際に使ってみる

### RDP クライアントを用いて、ログインする

+ ログイン方法 (macOS 版) は以下の 2 点です。
  + GCP 用の Chrome の拡張機能を使用する
    + [Chrome RDP for Google Cloud Platform](https://chrome.google.com/webstore/detail/chrome-rdp-for-google-clo/mpbbnannobiobpnfblimoapbephgifkm)
  + アプリを使用する
    + [Microsoft Remote Desktop 10](https://apps.apple.com/us/app/microsoft-remote-desktop-10/id1295203466)

今回は、Microsoft Remote Desktop 10 を使用します。

+ アプリケーションの起動し、左上の `+` から新規作成をします

![](./images/compute_win-vm-07.png)

+ 先程作成した VM の External IP を入力し `Add` します。

![](./images/compute_win-vm-08.png)

+ 登録が完了しました。

![](./images/compute_win-vm-09.png)

+ 先程設定した、RDP ログインのユーザとパスワードを入力します。

![](./images/compute_win-vm-10.png)

![](./images/compute_win-vm-11.png)

+ 無事、Windows Server にログインすることが出来ました。

![](./images/compute_win-vm-12.png)

### IE のセキュリティを一回 off

+ IE のセキュリティの問題
  + https://support.microsoft.com/en-us/help/815141/ie-enhanced-security-configuration-changes-browsing-experience

+ `Local Server` をクリックし、IE Enhanced Security Configuration の横の `On` をクリックします。

![](./images/compute_win-vm-13.png)

![](./images/compute_win-vm-14.png)

+ 設定が立ち上がるので、一時的に `Off` にします。

![](./images/compute_win-vm-15.png)

![](./images/compute_win-vm-16.png)

![](./images/compute_win-vm-17.png)

### Microsoft Edge を IE からダウンロードし、インストールします。

![](./images/compute_win-vm-18.png)

![](./images/compute_win-vm-19.png)

![](./images/compute_win-vm-20.png)

![](./images/compute_win-vm-21.png)

![](./images/compute_win-vm-22.png)

![](./images/compute_win-vm-23.png)

### IE のセキュリティを on

+ IE Enhanced Security Configuration を再度有効にします

![](./images/compute_win-vm-24.png)

![](./images/compute_win-vm-25.png)

## まとめ

GCE 上でも Windows Server は動かせます!!

Have fun!! :)
