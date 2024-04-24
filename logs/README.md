# Logging

+ 公式ドキュメント

https://cloud.google.com/logging/docs/agent/installation?hl=en

+ 実装方法
  + About the Logging agent
  + https://cloud.google.com/logging/docs/agent/

## Installing the Cloud Logging agent 

+ install (Linux Ver)

```
curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
sudo bash install-logging-agent.sh
```

+ Check Status

```
sudo service google-fluentd status
```

## Check Agent Version

+  Debian/Ubuntu

```
dpkg-query --show --showformat \
    '${Package} ${Version} ${Architecture} ${Status}\n' \
     google-fluentd \
     google-fluentd-catch-all-config \
     google-fluentd-catch-all-config-structured
```

+ CentOS/RHEL

```
rpm --query --queryformat '%{NAME} %{VERSION} %{RELEASE} %{ARCH}\n' \
     google-fluentd \
     google-fluentd-catch-all-config \
     google-fluentd-catch-all-config-structured
```


## log query

+ 全部の audit log を取ってくる

```
protoPayload."@type"="type.googleapis.com/google.cloud.audit.AuditLog"
```

## 様々なログ

### データアクセス監査ログを有効にする

https://cloud.google.com/logging/docs/audit/configure-data-access?hl=en


## memo

```
Logging のクエリ言語
https://cloud.google.com/logging/docs/view/logging-query-language?hl=ja
```
