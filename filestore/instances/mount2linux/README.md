# Linux にマウントする

## 概要

GCE で立てた Linux OS から Filestore をマウントする

```
### 公式ドキュメント

Compute Engine クライアントでのファイル共有のマウント
https://cloud.google.com/filestore/docs/mounting-fileshares
```


## やってみる

### OS 情報

+ 以下の OS を使って検証していきます

```
$ cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
NAME="Debian GNU/Linux"
VERSION_ID="11"
VERSION="11 (bullseye)"
VERSION_CODENAME=bullseye
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
```
