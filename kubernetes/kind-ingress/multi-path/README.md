# Ingress: Multi Path

## 準備

ドメインを用意しておく

```
WIP
```

## GCP と認証をする

```
gcloud auth login -q
```

## Static IP Adress を予約

```
gcloud beta compute addresses create multi-path \
    --ip-version=IPV4 \
    --global \
    --project ${_gcp_pj_id}
```

## 予約した Static IP Address をドメインの A レコードとして登録する

```
WIP
```

## GKE Cluster 上にリソースをデプロイする

```
kubectl apply -f main.yaml
```

## リソース削除

```
kubectl delete -f main.yaml
```
```
gcloud beta compute addresses delete multi-path \
    --global \
    --project ${_gcp_pj_id}
```

## 参考

+ ハンズオン
  + https://github.com/iganari/handson-gke/tree/main/10_hello-world


https://kubernetes.io/ja/docs/tasks/access-application-cluster/ingress-minikube/

参考
https://kubernetes.io/docs/concepts/services-networking/ingress/#name-based-virtual-hosting
