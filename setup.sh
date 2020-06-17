#!/bin/bash
kubectl create namespace crossplane-system

helm repo add crossplane-alpha https://charts.crossplane.io/alpha

# Kubernetes 1.15 and newer versions
helm install crossplane --namespace crossplane-system crossplane-alpha/crossplane

sleep 15

PACKAGE=crossplane/provider-aws:v0.10.0
NAME=provider-aws

kubectl crossplane package install --cluster --namespace crossplane-system ${PACKAGE} ${NAME}

AWS_PROFILE=default && echo -e "[default]\naws_access_key_id = $(aws configure get aws_access_key_id --profile $AWS_PROFILE)\naws_secret_access_key = $(aws configure get aws_secret_access_key --profile $AWS_PROFILE)" > creds.conf
    
kubectl create secret generic aws-creds -n crossplane-system --from-file=key=./creds.conf
kubectl apply -f redis-clusterrole.yaml
kubectl apply -f postgres-clusterrole.yaml
kubectl apply -f bucket-clusterrole.yaml
