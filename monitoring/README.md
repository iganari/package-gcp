# Monitoring

+ 公式ドキュメント

https://cloud.google.com/monitoring/agent/install-agent?hl=en

## Installing on Linux

---> Opd Agent に切り替わりました

### CentOS/RHEL

+ Add Repository

```
curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
sudo bash add-monitoring-agent-repo.sh
```

+ Install the agent

```
sudo yum list    -y stackdriver-agent
sudo yum install -y stackdriver-agent
```

+ Start the agent service

```
sudo service stackdriver-agent start
```

+ Check status

```
udo service stackdriver-agent status
```

## Check Agent Version

+ CentOS/RHEL

```
rpm --query --queryformat '%{NAME} %{VERSION} %{RELEASE} %{ARCH}\n' \
     stackdriver-agent
```

## プロセスを監視したい

### Linux のプロセス監視

https://cloud.google.com/monitoring/alerts/ui-conditions-ga?hl=ja#process-health

### Windows のプロセス監視

現状無理
