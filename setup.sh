#!/bin/bash

source variables.env

kubectl create namespace crossplane-system

helm repo add crossplane-alpha https://charts.crossplane.io/alpha

helm install crossplane --namespace crossplane-system crossplane-alpha/crossplane

kubectl apply -f roles.yaml

kubectl crossplane package install --cluster --namespace crossplane-system ${AWSPROVIDER} ${PROVIDERNAME} > /dev/null
JSONPATH='{..status.conditionedStatus.conditions[0].status}'

echo "Waiting up to 30s for the provider to come up"

while [[ $(kubectl get -n crossplane-system clusterpackageinstall.packages.crossplane.io/${PROVIDERNAME} -o jsonpath=$JSONPATH) != "True" ]]
do echo "Waiting for Provider" && sleep 1
done

echo "Provider is up"

./awscreds.sh

oc apply -f aws_provider.yaml

./compositions/setup.sh

./make_dependencies.sh