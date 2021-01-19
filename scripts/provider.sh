#!/bin/bash
source variables.env

kubectl apply -f ./manifests/controllerconfig.yaml

./scripts/awscreds.sh

until kubectl get customresourcedefinition.apiextensions.k8s.io/providerconfigs.aws.crossplane.io > /dev/null 2>&1 
do
  sleep 2
done

until kubectl get customresourcedefinition.apiextensions.k8s.io/providerconfigs.helm.crossplane.io > /dev/null 2>&1 
do
  sleep 2
done

until kubectl get customresourcedefinition.apiextensions.k8s.io/providerconfigs.in-cluster.crossplane.io > /dev/null 2>&1 
do
  sleep 2
done

kubectl apply -f ./manifests/providers.yaml
