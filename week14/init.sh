#!/bin/bash

# helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# install jenkins
helm repo add jenkins https://charts.jenkins.io
hel repo add https://kubernetes.github.io/ingress-nginx
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm upgrade --install ingress-nginx ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --values yaml/ingress-value.yaml \
  --version "4.8.4" \
  --wait

# create ns
kubectl create ns jenkins

# service account for kubernetes secret provider
kubectl apply -f /tmp/jenkins-service-account.yaml -n jenkins

# jenkins github personal access token
kubectl apply -f /tmp/github-personal-token.yaml -n jenkins

# jenkins github server(system) pat secret
kubectl apply -f /tmp/github-pat-secret-text.yaml -n jenkins

# install jenkins helm
helm upgrade -i jenkins jenkins/jenkins -n jenkins --create-namespace \
  -f /tmp/jenkins-values.yaml --version "4.6.1"


kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f /tmp/argocd-dashboard-ingress.yaml -n argocd

helm upgrade -i crossplane \
--namespace crossplane-system \
--create-namespace crossplane-stable/crossplane \
--version "1.14.0" \
--wait

kubectl apply -f /tmp/tf-provider.yaml -n crossplane-system

kubectl apply -f /tmp/argocd-applicationset.yaml -n argocd