# Tips

## Container-Optimized OS にてデバックする

---> toolbox を使う ---> https://cloud.google.com/container-optimized-os/docs/how-to/toolbox?hl=ja

+ OS の確認

```
cat /etc/os-release
```
```
### Ex.

BUILD_ID=12371.251.0
NAME="Container-Optimized OS"
KERNEL_COMMIT_ID=5d4ffd91281840f7a118143d77fbefb02e87943c
GOOGLE_CRASH_ID=Lakitu
VERSION_ID=77
BUG_REPORT_URL="https://cloud.google.com/container-optimized-os/docs/resources/support-policy#contact_us"
PRETTY_NAME="Container-Optimized OS from Google"
VERSION=77
GOOGLE_METRICS_PRODUCT_ID=26
HOME_URL="https://cloud.google.com/container-optimized-os/docs"
ID=cos
```

+ toolbox の起動

```
echo "TOOLBOX_DOCKER_IMAGE=fedora" > "${HOME}/.toolboxrc"
echo "TOOLBOX_DOCKER_TAG=latest" >> "${HOME}/.toolboxrc"
toolbox
```
