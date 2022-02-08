# kind: CronJob

## 公式 ドキュメント

+ GCP ドキュメント
https://cloud.google.com/kubernetes-engine/docs/how-to/cronjobs

+ Kubernetes ドキュメント
https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/

## サンプル

```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: xxxx
spec:
  schedule: "*/30 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: xxxx
              image: REPLACED_WITH_DOCKER_IMAGE_NAME
              command: ["sh", "-c"]
              args:
                - |
                  /xxx.sh
          restartPolicy: Never
```
```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            args:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure
```



参考

+ https://cstoku.dev/posts/2018/k8sdojo-14/
+ https://kakakakakku.hatenablog.com/entry/2020/04/07/104457

## crontab 

+ `spec.schedule` は UTC
  + 故に JST で考えた時に、 `-9 時間` して記載する必要がある
  + https://cloud.google.com/kubernetes-engine/docs/how-to/cronjobs#schedule
