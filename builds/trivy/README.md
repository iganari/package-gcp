# Trivy とは

+ コンテナイメージ内の OS やライブラリやモジュールなどの脆弱性のチェック
+ 基本的には apt update とか yum update でアップデートしてから Trivy にてチェックしたほうが良い

もともとは日本人が個人で作成したソフトウェアが企業に譲渡された形。今も OSS として開発は続けている模様

https://knqyf263.hatenablog.com/entry/2019/08/20/120713

## サンプル

+ cloudbuild.yaml

```
# scan Vulnerability of the container image
steps:
  - id: "Check Trivy"
    name: 'aquasec/trivy'
    entrypoint: ash
    args:
      - -c
      - |
        echo "check trivy"
        trivy -o /dev/stdout gcr.io/$PROJECT_ID/${_container_id}:latest
        if [ "$?" = '0' ]; then :; else exit 1; fi
  - id: "Check Image by Trivy"
    name: 'aquasec/trivy'
    entrypoint: ash
    args:
      - -c
      - |
        apk update
        apk add curl 
        trivy --exit-code=1 --severity=CRITICAL,HIGH -o /dev/stdout gcr.io/$PROJECT_ID/${_container_id}:latest
        if [ "$?" = '0' ]; then :; else exit 1; fi
```
