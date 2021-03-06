# StatefulSet: MySQL

## 実行方法

### 認証

+ GKE Cluster との認証

```
gcloud container clusters get-credentials {Your GKE Cluster}
```

### GKE Cluster にデプロイ

+ base64 でエンコード

```
export _mysql_root_password=`echo -n '{YOUR DB ROOT PASSWORD}' | base64`
export _mysql_database=`echo -n 'my_database' | base64`
export _mysql_user=`echo -n 'my_dbadmin' | base64`
export _mysql_password=`echo -n '{YOUR MYSQL USER PASSWORD}' | base64`
```

+ 確認

```
echo "MYSQL_ROOT_PASSWORD is ${_mysql_root_password}"
echo "MYSQL_DATABASE is ${_mysql_database}"
echo "MYSQL_USER is ${_mysql_user}"
echo "MYSQL_PASSWORD is ${_mysql_password}"
```

+ Secret を書き換え

```
cp -a mysql.yaml.template                                 mysql.yaml
sed -i "s/_MYSQL_ROOT_PASSWORD/${_mysql_root_password}/g" mysql.yaml
sed -i "s/_MYSQL_DATABASE/${_mysql_database}/g"           mysql.yaml
sed -i "s/_MYSQL_USER/${_mysql_user}/g"                   mysql.yaml
sed -i "s/_MYSQL_PASSWORD/${_mysql_password}/g"           mysql.yaml
```

+ GKE Cluster にデプロイ

```
kubectl apply -f mysql.yaml
```

+ 確認コマンド

```
kubectl get statefulset
```
```
kubectl get service
```
```
kubectl get pod
```
```
kubectl get secret
```

### MySQL の Pod の中からログインテスト

+ Pod の一つにログイン

```
kubectl exec -it {POD 名} /bin/sh
```

+ Pod の中での作業

```
mysql -u my_dbadmin -p
```
```
### 例

# mysql -u my_dbadmin -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 8.0.23 MySQL Community Server - GPL

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

+ Pod からログアウト

```
exit
```

### MySQL の Pod の外からログインテスト

+ MySQL の Deployment を１個起動する

```
kubectl run mysql-client --image=mysql:8.0.23 --env="MYSQL_ALLOW_EMPTY_PASSWORD=yes"
```

+ 確認

```
kubectl get deployment
kubectl get pod
```

+ 起動した Deployment の MySQL にログインする

```
kubectl exec -it $(kubectl get pod | grep mysql-client | awk '{print $1}') /bin/sh
```

+ Statefulset の MySQL にログインする

```
mysql -h mysql-svc -u my_dbadmin -p
```

```
### 例

# mysql -h mysql-svc -u my_dbadmin -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.23 MySQL Community Server - GPL

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```
```
exit
```

## リソースの削除

+ リソースの削除

```
kubectl delete -f mysql.yaml
```

+ persistentVolumeClaim の削除
    + StatefulSet の場合はこの作業が必要

```
kubectl get pvc | awk 'NR>1 {print $1}' | xargs kubectl delete pvc
```
