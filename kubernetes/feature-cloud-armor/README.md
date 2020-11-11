# Cloud Armor

## やりたいこと

+ GKE のセキュリティを高めたい
  + Cloud Armor の機能の 1 つに `IP アドレス制限` があるので、それを使う

## 出来ること

+ Cloud Armor の IP アドレス制限を GKE 上の Service につけることが出来る
  + ingress の Service 単位で Cloud Armor の設定をつけることが出来る

## 設定

1. Cloud Armor の設定
1. manifest で BackendConfig の設定を作成
1. manifest で Service に annotations を追加

### Cloud Armor の設定

+ コマンドラインで Cloud Armor を作成

```
### 環境変数

export _armor_name='ip-addr-whitelist'
export _project='Your GCP Project ID'

```
```
### 設定の作成

gcloud beta compute security-policies create ${_armor_name} \
    --description "armor-sample" \
    --project ${_project}
```
```
### 基本 deny の設定

gcloud compute security-policies rules update 2147483647 \
    --security-policy ${_armor_name} \
    --action "deny-403" \
    --project ${_project}
```
```
### 許可したい IP アドレスを追加(例として、インターナルとイクスターナル(適当)を許可)

gcloud compute security-policies rules create 1000 \
    --security-policy ${_armor_name} \
    --description "allow traffic from internal" \
    --src-ip-ranges "192.0.2.0/24,172.16.3.0/24" \
    --action "allow"

gcloud compute security-policies rules create 2000 \
    --security-policy ${_armor_name} \
    --description "allow traffic from extermal" \
    --src-ip-ranges "216.58.220.142/32,216.58.220.143/32" \
    --action "allow"
```

+ GCP コンソールで確認
  + この状態ではどのリソースに対しても適用されていないため、 `Apply policy to target` が出ている

![](./feature-cloud-armor-01.png)

![](./feature-cloud-armor-02.png)

### manifest で BackendConfig の設定を作成

```
apiVersion: cloud.google.com/v1beta1
kind: BackendConfig
metadata:
  name: backend-config-sample
  namespace: default
spec:
  securityPolicy:
    name: "ip-addr-whitelist"
```

### manifest で Service に annotations を追加

+ 例として nginx を起動する

+ manifest を作る

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: default
  labels:
    app: nginx
    env: sample
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
      env: sample
  template:
    metadata:
      labels:
        app: nginx
        env: sample
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: default
  labels:
    app: nginx
    env: sample
  annotations:
    beta.cloud.google.com/backend-config: '{"ports": {"80":"backend-config-sample"}}'  ## Google Cloud Armor
spec:
  type: NodePort
  selector:
    app: nginx
    env: sample
  ports:
    - port: 8080
      targetPort: 80

---

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: nginx-ingress
  namespace: default
  labels:
    app: nginx
    env: sample
spec:
  rules:
  - http:
      paths:
      - path: /*
        backend:
          serviceName: nginx-service
          servicePort: 8080

```


+ apply

```
kubectl apply -f k8s.yaml
```

## イメージ

+ ブラウザのイメージ(alloy, deny)
+ GCP コンソールのイメージ




## 参考

+ https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-features?hl=en#cloud_armor
+ https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-features?hl=en#exercise
