# Install Default WordPress using Helm

+ Official Document
  + https://hub.helm.sh/charts/bitnami/wordpress

```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/wordpress
```
```
### Ex.

# helm install my-release bitnami/wordpress
NAME: my-release
LAST DEPLOYED: Wed Jun 17 04:21:19 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
** Please be patient while the chart is being deployed **

To access your WordPress site from outside the cluster follow the steps below:

1. Get the WordPress URL by running these commands:

  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        Watch the status with: 'kubectl get svc --namespace default -w my-release-wordpress'

   export SERVICE_IP=$(kubectl get svc --namespace default my-release-wordpress --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
   echo "WordPress URL: http://$SERVICE_IP/"
   echo "WordPress Admin URL: http://$SERVICE_IP/admin"

2. Open a browser and access WordPress using the obtained URL.

3. Login with the following credentials below to see your blog:

  echo Username: user
  echo Password: $(kubectl get secret --namespace default my-release-wordpress -o jsonpath="{.data.wordpress-password}" | base64 --decode)
```
 
+ Check Your Web Browser

![](../img/helm-wp-default-01.png)

![](../img/helm-wp-default-02.png)

You did it!! :)