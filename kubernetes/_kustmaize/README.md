# kustmaize について

## 概要

WIP

```
公式ページ
https://kubectl.docs.kubernetes.io/installation/kustomize/
```

## インストール方法

### Linux 全般

+ バイナリをダウンロード

```
sudo su -

cd /usr/local/bin
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
chmod 0755 kustomize

exit
```

+ 確認

```
kustomize --version
```

### macOS

https://kubectl.docs.kubernetes.io/installation/kustomize/homebrew/

+ For Homebrew users

```
brew install kustomize
```

+ For MacPorts users

```
sudo port install kustomize
```

### Windows

https://kubectl.docs.kubernetes.io/installation/kustomize/chocolatey/

+ For Windows using Chocolatey

```
choco install kustomize
```
