# セルフマネージド SSL 証明書を使う

## 概要

+ 公式ドキュメント
  + [Using self-managed SSL certificates](https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs?hl=en)

## やってみる

以下の条件でやってみます

+ 自己署名証明書(おれおれ証明書)
  + ワイルドカード

## GKE クラスタとリソースをデプロイする

+ 使用する環境変数

```
### Env

export _common='sslself'
export _gcp_pj_id='Your GCP Project ID'
export _region='asia-northeast1'
export _sub_network_range='10.146.0.0/20'
```

+ GKE クラスタを作成する
  + [Package GCP | Create Public Cluster of Standard mode](https://github.com/iganari/package-gcp/tree/main/kubernetes/about-cluster/standard-public-gcloud)
+ マルチドメイン設定の Ingress をデプロイする
  + [Package GCP | Ingress: Multi Domain](https://github.com/iganari/package-gcp/tree/main/kubernetes/kind-ingress/multi-domain)


## 秘密鍵と証明書を作成する

https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs#create-key-and-cert

+ 秘密鍵の作成
  + PEM 形式
  + `RSA-2048` OR `ECDSA P-256` である必要がある

```
openssl genrsa -out ${_common}-key.pem 2048
```

+ 証明書署名リクエスト（CSR）の生成
  + PEM 形式
  + 証明書発行要求 ともいう

```
openssl req -new -key ${_common}-key.pem -out ${_common}-key.csr

---> 対話形式になる
```
```
### 例

$ openssl req -new -key ${_common}-key.pem -out ${_common}.csr
Can't load /home/iganari/.rnd into RNG
140596809327040:error:2406F079:random number generator:RAND_load_file:Cannot open file:../crypto/rand/randfile.c:88:Filename=/home/iganari/.rnd
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:JP                           // 「JP」と入力
State or Province Name (full name) [Some-State]:Tokyo          // 「Tokyo」と入力
Locality Name (eg, city) []:Shinjuku                           // 「Shinjuku」と入力
Organization Name (eg, company) [Internet Widgits Pty Ltd]:    // 何も入力せずに Enter
Organizational Unit Name (eg, section) []:                     // 何も入力せずに Enter
Common Name (e.g. server FQDN or YOUR name) []:*.iganari.xyz   // 「*.iganari.xyz」と入力
Email Address []:                                              // 何も入力せずに Enter

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:               // 何も入力せずに Enter
An optional company name []:           // 何も入力せずに Enter
```

+ 自己署名証明書
  + 所謂オレオレ証明書発行
  + 10 年間

```
openssl x509 -req \
  -signkey ${_common}-key.pem \
  -in ${_common}.csr \
  -out ${_common}.crt \
  -days 3650
```
```
### 例

$ openssl x509 -req \
>   -signkey ${_common}-key.pem \
>   -in ${_common}.csr \
>   -out ${_common}.crt \
>   -days 3650
Signature ok
subject=C = JP, ST = Tokyo, L = Shinjuku, O = Internet Widgits Pty Ltd, CN = *.iganari.xyz
Getting Private key
```

+ ここまでで 3 つのファイルが出来ました

```
$ ls -1 | grep ${_common}
sslself-key.pem
sslself.crt
sslself.csr
```

## セルフマネージド SSL 証明書リソースを作成する

https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs#createresource

## セルフマネージド SSL 証明書リソースを作成する

https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs#associate-target-proxy



## 有効期限が切れる前に SSL 証明書を置き換えまたは更新する

https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs#replacing-certificates



