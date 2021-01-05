# Trivy

+ コンテナイメージ内の OS やライブラリやモジュールなどの脆弱性のチェック
+ 基本的には apt update とか yum update でアップデートしてから Trivy にてチェックしたほうが良い

## サンプル

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
