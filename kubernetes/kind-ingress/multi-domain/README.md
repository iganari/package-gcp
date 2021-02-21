# Ingress: Multi Domain

## 準備

ドメインを用意しておく

```
multi-domain.hejda.org
```

## GCP と認証をする

```
gcloud auth login -q
```

## Static IP Adress を予約

```
gcloud beta compute addresses create multi-domain \
    --ip-version=IPV4 \
    --global \
    --project ${_gcp_pj_id}
```

## 予約した Static IP Address をドメインの A レコードとして登録する

```
# dig A int-raspi01.hejda.org +short
192.168.202.30
```

## GKE Cluster 上にリソースをデプロイする

```
kubectl apply -f main.yaml
```

## 参考

+ ハンズオン
  + https://github.com/iganari/handson-gke/tree/main/10_hello-world


https://kubernetes.io/ja/docs/tasks/access-application-cluster/ingress-minikube/

参考
https://kubernetes.io/docs/concepts/services-networking/ingress/#name-based-virtual-hosting

34.120.125.119