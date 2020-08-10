#!/bin/bash
source variables.env

kubectl crossplane package install --cluster --namespace crossplane-system ${AWSPROVIDER} ${PROVIDERNAME} > /dev/null
JSONPATH='{..status.conditionedStatus.conditions[0].status}'

echo "Waiting for the provider to come up"

while [[ $(kubectl get -n crossplane-system clusterpackageinstall.packages.crossplane.io/${PROVIDERNAME} -o jsonpath=$JSONPATH) != "True" ]]
do echo "Waiting for Provider" && sleep 1
done

echo "Provider is up"

./scripts/awscreds.sh

oc apply -f aws_provider.yaml