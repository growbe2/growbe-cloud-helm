
# Configuration of a kubernetes server with microk8s

This is an exemple on how to setup growbe-cloud on a microk8s cluster than you can run on any
kind of device.


```bash
sudo snap install microk8s --classic
sudo usermod -a -G microk8s $USER
microk8s enable dashboard dns storage ingress prometheus openfaas

# Adding loki and promtail
helm upgrade --namespace monitoring --install loki grafana/loki
helm upgrade --namespace monitoring --install promtail grafana/promtail --set "config.lokiAddress=http://loki.obsv.svc.cluster.local:3100/loki/api/v1/push"

# Copy to your machine to start working on the cluster
microk8s config > .cluster_config

# To generate the certificate for remote access to the cluster
# https://stackoverflow.com/questions/63451290/microk8s-devops-unable-to-connect-to-the-server-x509-certificate-is-valid-f
# Add this to your locale .zshrc or bashrc
alias kubectl='kubectl --kubeconfig=/home/wq/.cluster_config'
alias kubectl_dashboard_token='kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)'
[[ /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)

# Setup git hub registery
# do a docker login in ghrc.io and add your config file to k8s as a secret
kubectl create secret generic ghcr \    --from-file=.dockerconfigjson=config.json \
    --type=kubernetes.io/dockerconfigjson


# Setup DO secret (https://cert-manager.io/docs/configuration/acme/dns01/digitalocean/)


# Add cred for docker for openfaas
kubectl create secret docker-registry dockerhub \     
    -n openfaas-fn \
    --docker-username=berlingoqc --docker-server=ghcr.io \
    --docker-password=PASSWORD \
    --docker-email=william95quintalwilliam@outlook.com

# Configure openfaas
kubectl port-forward -n openfaas svc/gateway 8080:8080 &
export OPENFAAS_URL=http://127.0.0.1:8080
export PASSWORD=$(kubectl -n openfaas get secret basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode)
echo -n $PASSWORD | faas-cli login -g $OPENFAAS_URL -u admin --password-stdin

```