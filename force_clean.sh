#!/bin/bash
source variables.env

oc delete -f requirements/
./compositions/teardown.sh
oc delete -f aws_provider.yaml
oc delete secret generic aws-creds
oc crossplane package uninstall --cluster --namespace crossplane-system ${PROVIDERNAME} > /dev/null
oc delete -f roles.yaml
helm uninstall crossplane --namespace crossplane-system
# oc get crds -o name | grep crossplane | xargs oc delete
# oc get crds -o name | grep crossplane | sed 's/.*\///' | xargs -n1 oc get -n crossplane-system -o name | xargs oc patch -n crossplane-system -p '{"metadata":{"finalizers":[]}}' --type=merge
oc delete namespace crossplane-system

# PACKAGE=krishchow/provider-aws:latest
# NAME=provider-aws
# oc delete -f aws_provider.yaml
# kubectl crossplane package uninstall --cluster --namespace crossplane-system ${NAME}
# oc get crds -o name | grep oam | xargs oc delete 
# kind delete cluster