# Sample Master Only

## memo

```
sh docker-build-run.sh 
```
```
touch service_account.json
```

```
gcloud auth login


export _pj='iganari_test-qr'
gcloud config set project ${_pj}

terraform workspace new ${_pj}
terraform workspace select ${_pj}





```
```
terraform init
terraform plan
terraform apply
```
```
terraform destroy
```
