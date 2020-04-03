# Logging

+ 公式ドキュメント

https://cloud.google.com/logging/docs/agent/installation?hl=en

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

+ Check Agent Version (Debian/Ubuntu)

```
dpkg-query --show --showformat \
    '${Package} ${Version} ${Architecture} ${Status}\n' \
     google-fluentd \
     google-fluentd-catch-all-config \
     google-fluentd-catch-all-config-structured
```
