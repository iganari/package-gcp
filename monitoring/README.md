# Monitoring

+ 公式ドキュメント

https://cloud.google.com/monitoring/agent/install-agent?hl=en

## Installing on Linux

### CentOS/RHEL

+ Add Repository

```
curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
sudo bash add-monitoring-agent-repo.sh
```

+ Install the agent

```
sudo yum list -y stackdriver-agent
```

+ Start the agent service

```
sudo service stackdriver-agent start
```



---> 失敗する

```
$ sudo service stackdriver-agent start
Redirecting to /bin/systemctl start stackdriver-agent.service
Failed to start stackdriver-agent.service: Unit not found.
```



## Check Agent Version

+ CentOS/RHEL

```
sudo service stackdriver-agent status
```
