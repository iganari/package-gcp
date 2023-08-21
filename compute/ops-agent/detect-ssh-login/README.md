# SSH ログインを Ops Agent の機能を使って検知する

## 以下のように記載

+ デフォルト
  + `/etc/google-cloud-ops-agent/config.yaml`
  + このファイルに書くと同じ識別子はオーバーライドされる

```
logging:
  receivers:
    syslog:
      type: files
      include_paths:
      - /var/log/messages
      - /var/log/syslog
      - /var/log/auth.log
  service:
    pipelines:
      default_pipeline:
        receivers: [syslog]
```


+ Ops Agent の再起動

```
sudo systemctl restart google-cloud-ops-agent
```

+ Ops Agent の状態確認

```
sudo systemctl status google-cloud-ops-agent
```

+ Cloud Logging での検出クエリ例

```
resource.type="gce_instance"
logName="projects/{{ Your Google Cloud Project ID }}/logs/syslog"
jsonPayload.message=~ ".*Accepted publickey.*"
```
