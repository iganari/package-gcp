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
### 設定の作成

gcloud beta compute security-policies create ingress-ip-whitelist --description "armor-sample"
```
```
### 基本 deny の設定

gcloud compute security-policies rules update 2147483647 \
    --security-policy ingress-ip-whitelist \
    --action "deny-403"
```
```
### 許可したい IP アドレスを追加

gcloud compute security-policies rules create 10000 \
    --security-policy ingress-ip-whitelist \
    --description "allow traffic from 192.0.2.0/24,172.16.3.0/24" \
    --src-ip-ranges "192.0.2.0/24,172.16.3.0/24" \
    --action "allow"
```

+ GCP コンソールで確認

WIP

### manifest で BackendConfig の設定を作成

```
apiVersion: cloud.google.com/v1beta1
kind: BackendConfig
metadata:
  namespace: default
  name: my-backend-config
spec:
  securityPolicy:
    name: "ingress-ip-whitelist"
```

### manifest で Service に annotations を追加

```
apiVersion: v1
kind: Service
metadata:
  namespace: default
  name: my-app-service
  labels:
    app: web
  annotations:
    beta.cloud.google.com/backend-config: '{"ports": {"80":"my-backend-config"}}'
spec:
  type: NodePort
  selector:
    app: web
  ports:
  - port: 80
    protocol: TCP
    targetPort: 8080
```


## 参考

+ https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-features?hl=en#cloud_armor
+ https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-features?hl=en#exercise
