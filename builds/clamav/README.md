# ClamAV

## ClamAV とは

オープンソースのセキュリティソフトのアンチウイルスエンジンです。

ClamAVは、「ファイルスキャン」「電子メールスキャン」「Webスキャン」などエンドポイントセキュリティを含むさまざまな状況で使用されるアンチウイルスエンジンです。

特に、UNIX/Linux環境では定番アンチウイルスツールとして利用されています。

公式HP https://www.clamav.net/

参考 https://www.ossnews.jp/oss_info/ClamAV

## ClamAV を Cloud Build 内で使用する

+ cloudbuild.yaml

```
steps:
  - id: "container virus scanning"
    name: 'alpine:edge'
    entrypoint: ash
    dir: 'apps'
    args:
      - -c
      - |
       apk update && \
       apk add clamav curl && \
       freshclam && \
       clamscan --infected --remove --recursive ./var/www/html
       if [ "$?" = '0' ]; then :; else echo "As a result of running a scan, a virus was found and cloudbuild removed it." ; fi
```
