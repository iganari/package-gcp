# for Terraform

## IAP をつける場合

Google Cloud の OAuth 2.0 Client IDs が API 経由で作成が出来ないため、完全に Terraform で構築できないので、以下の手順をする (2024/02)

## 1. Cloud Console で OAuth 2.0 Client IDs を作成

+ `Web application` を指定して Client ID を作成
+ 他のパラメータは無しでも良い

<details>
<summary>スクリーンショット</summary>

![](./_img/01-01.png)

![](./_img/01-02.png)

![](./_img/01-03.png)

![](./_img/01-04.png)

![](./_img/01-05.png)

</details>

## 2. 作成した ID を修正

`Client ID` の値を使って `Authorized redirect URIs` を登録

```
https://iap.googleapis.com/v1/oauth/clientIds/{{ Client ID }}:handleRedirect
```

<details>
<summary>スクリーンショット</summary>

![](./_img/02-01.png)

![](./_img/02-02.png)

![](./_img/02-03.png)

</details>
