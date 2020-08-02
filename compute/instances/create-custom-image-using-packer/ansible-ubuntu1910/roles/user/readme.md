# user

## 注意点

:warning: 環境変数を暗号化しているため、復号化の処理が必要 :warning:

作業に関しては以下の2点が想定出来る

+ ansibleを流すサーバ内から行う(ansible-local)
+ ansibleを流すサーバ外から行う(ansible-remote)

また、このroleはテンプレートのため、実際にRepositoryでuser roleを使いたい場合は、roleをコピーしましょう

### 用語

+ ansibleを実行するサーバ
    + クライアント
+ ansibleで実行されるサーバ
    + ホスト(複数の場合もある)

## Case1 ansibleを自身に行う(クライアント = ホスト)

### 構成例

:package:(Vagrant) 内でanibleを実行する

### 準備

+ Vagrantを立ち上げる

```
cd package-ansible-playbook/centos-7/opsfiles/vagrant
sh prepare.sh
```

---> 以降はVagrant内 :package:

### :package: ROOT化

```
sudo su -
```

### :package: role[common]が冪等性を持って流せるか確認する

+ 移動

```
cd /develop/vg-centos7
```

+ Dry RUN

```
ansible-playbook -i inventoryfile/vagrant-local servers.yml \
                 -l vagrant-local \
                 --tag common \
                 --check \
                 --diff
```

+ RUN

```
ansible-playbook -i inventoryfile/vagrant-local servers.yml \
                 -l vagrant-local \
                 --tag common 
```


### :package: user roleのvarsの編集

+ 鍵のコピー

```
cp -a roles/common/files/root/_vault_password_file /tmp/.vault_password_file
chmod 0600 /tmp/.vault_password_file
```

+ 編集

```
ansible-vault edit \
              --vault-password-file /tmp/.vault_password_file \
              roles/user/vars/main.yml
```

### :package: ansible-playbook 実行

+ Dry RUN

```
ansible-playbook -i inventoryfile/vagrant-local servers-vault.yml \
                 -l vagrant-local \
                 --tag user \
                 --vault-password-file /tmp/.vault_password_file \
                 --check \
                 --diff
```

+ RUN

```
ansible-playbook -i inventoryfile/vagrant-local servers-vault.yml \
                 -l vagrant-local \
                 --tag user \
                 --vault-password-file /tmp/.vault_password_file
```


## Case2 ansibleを自身に行う(クライアント != ホスト)

:warning: WIP

### 構成例

:whale:(Dockerコンテナ) --> :package:(Vagrant) へansibleを行う

### 準備

+ ホストとしてVagrantを立ち上げておく

```
cd package-ansible-playbook/centos-7/opsfiles/vagrant
sh prepare.sh
```

+ :package: 公開鍵の設定を行う

```
sudo mkdir /root/.ssh
sudo chmod 0700 /root/.ssh
sudo curl 'https://gist.githubusercontent.com/iganari/c5dba6339e674c30303c5e92718e5a30/raw/9ad5f6c99717a7839b65d81c6a631e866c939892/id_rsa-hejda-tmp.pub' -o /root/.ssh/authorized_keys
```
```
exit
```

+ クライアントとしてDockerコンテナを立ち上げる

```
cd package-ansible-playbook/centos-7/opsfiles/ansible-client
sh docker-build-run.sh
```

---> 以降はDockerコンテナ内 :whale:


### :whale: role[common]が冪等性を持って流せるか確認する(WIP)

+ ホストとのSSH通信を確認する

```
chmod 0600 _ssh/id_rsa-hejda-tmp
ssh -i _ssh/id_rsa-hejda-tmp root@$(cat inventoryfile/vagrant-remote | awk 'NR==2')
```
```
exit
```

+ ansibleにて通信が出来ることを確認する

```
WIP
```

+ Dry RUN

```
ansible-playbook -i inventoryfile/vagrant-local servers.yml \
                 -l vagrant-local \
                 --tag common \
                 --check \
                 --diff
```

+ RUN

```
ansible-playbook -i inventoryfile/vagrant-local servers.yml \
                 -l vagrant-local \
                 --tag common 
```


### :package: user roleのvarsの編集(WIP)

+ 鍵のコピー

```
cp -a roles/common/files/root/_vault_password_file /tmp/.vault_password_file
chmod 0600 /tmp/.vault_password_file
```

+ 編集

```
ansible-vault edit \
              --vault-password-file /tmp/.vault_password_file \
              roles/user/vars/main.yml
```

### :package: ansible-playbook 実行(WIP)

+ Dry RUN

```
ansible-playbook -i inventoryfile/vagrant-local servers-vault.yml \
                 -l vagrant-local \
                 --tag user \
                 --vault-password-file /tmp/.vault_password_file \
                 --check \
                 --diff
```

+ RUN

```
ansible-playbook -i inventoryfile/vagrant-local servers-vault.yml \
                 -l vagrant-local \
                 --tag user \
                 --vault-password-file /tmp/.vault_password_file
```
