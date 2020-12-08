#!/bin/bash
source variables.env

oc crossplane package install --cluster --namespace crossplane-system ${AWSPROVIDER} ${PROVIDERNAME}
JSONPATH='{..status.conditionedStatus.conditions[0].status}'
echo "Waiting for the provider to come up"
while [[ $(oc get -n crossplane-system deployment provider-aws-controller | wc -l) != 2 ]]
do echo "Waiting for Controller" && sleep 1
done

kubectl get deployment provider-aws-controller -n crossplane-system -o json \
    | jq '.spec.template.spec.securityContext = {runAsNonRoot: true}' \
    | kubectl replace -f -

while [[ $(oc get -n crossplane-system clusterpackageinstall.packages.crossplane.io/${PROVIDERNAME} -o jsonpath=$JSONPATH) != "True" ]]
do echo "Waiting for Provider" && sleep 1
done

echo "Provider is up"

./scripts/awscreds.sh

sleep 10

oc apply -f ./manifests/providers.yaml
