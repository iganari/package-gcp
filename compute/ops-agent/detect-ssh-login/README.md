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

## 以下はアディショナル

```
export _gc_pj_id='ca-igarashi-test-i'
export _common='detect-ssh-login'
```

```
gcloud beta pubsub topics create ${_common}-topic --project ${_gc_pj_id}
```
```
gcloud beta pubsub subscriptions create ${_common}-sub-pull \
--topic ${_common}-topic \
--topic-project ${_gc_pj_id} \
--message-retention-duration 6d \
--expiration-period 14d \
--project ${_gc_pj_id}
```
