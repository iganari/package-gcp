# Cron Jobs

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



参考

+ https://cstoku.dev/posts/2018/k8sdojo-14/
+ https://kakakakakku.hatenablog.com/entry/2020/04/07/104457


+ sample01の場合

```
watch -n2 kubectl get po
```


```
NAME                     READY   STATUS      RESTARTS   AGE
hello-1622100900-hdsw6   0/1     Completed   0          2m13s
hello-1622100960-hlmcm   0/1     Completed   0          73s
hello-1622101020-mmw2c   0/1     Completed   0          12s
```
```
# kubectl logs -f hello-1622100900-hdsw6
Thu May 27 07:35:11 UTC 2021
Hello, World!
```