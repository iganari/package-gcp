# VPC Service Controls

## :warning: 注意 

VPC Service Controls は組織リソースです

## 概要

+ VPC Service Controls とは

```
セキュリティ境界(perimeter) を作成し、その境界内入れる API を指定します
境界内に指定した API を使用するコンポーネントは、境界内からのみアクセス可能になり、境界外からはアクセスすることは出来なくなります
これは同じ GCP Project 内においても同様です

ゆえに、VPC Service Controls はマルチテナントサービス用の多層防御における新たな制御層として機能し、内部脅威と外部脅威の両方からサービスへのアクセスを保護します

VPC ネットワークを使用しないサービス(=一度外部のインターネットに出るようなコンポーネント)は Service Account を別途登録するなどして許可する必要があります
```

## 参考 URL

[VPC Service Controls](https://cloud.google.com/vpc-service-controls)

[サポートされているプロダクトと制限事項](https://cloud.google.com/vpc-service-controls/docs/supported-products)

[VPC Service Controls の概要](https://cloud.google.com/vpc-service-controls/docs/overview)

[Google Cloud Japan | 実例から学ぶ、VPC Service Control Deep Dive](https://www.youtube.com/watch?v=Tx4cIhc2Fqk)

[境界ブリッジの例](https://cloud.google.com/vpc-service-controls/docs/share-across-perimeters#example_of_perimeter_bridges)

## 図とか

![](https://cloud.google.com/vpc-service-controls/images/service_perimeter.png)

![](https://cloud.google.com/vpc-service-controls/images/service_perimeter_private.png)

![](https://cloud.google.com/vpc-service-controls/images/service_perimeter_internet.png)
