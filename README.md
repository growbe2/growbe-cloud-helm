# Growbe cloud public 

The repository contains all the docker image and helm chart to deploy a instance of growbe-cloud on kubernetes


Two chart need to be deployed:

* growbe-cloud-chart
* growbe-cloud-secrets-chart


## Configure a new cluster


### Add the required infrastructure inside the cluster

* Nginx Ingress
* Cert Manager

```bash
# Add ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/do/deploy.yaml
# Add cert manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.0/cert-manager.yaml

# Soon to be optional because all image are gonna be public
kubectl -n growbe-prod create secret docker-registry ghcr --docker-server=ghcr.io --docker-username=${USERNAME] --docker-password=${PASSWORD} --docker-email=${EMAIL}

# If https , you need to create the ressource for your issuer
# and i need to modify the template for it to work like that
```

```bash
# Create your namespace
kubectl create namespace ${NAMESPACE}

# Deploy your secret chart

# Deploy your application chart

# Run script to populate the database with default user name or what
```