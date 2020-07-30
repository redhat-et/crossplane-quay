#!/bin/bash
cd $(dirname $0)

oc apply -f pull.yaml
oc apply -f RBAC/service_account.yaml
oc apply -f RBAC/role.yaml
oc apply -f RBAC/role_binding.yaml
oc apply -f redhatcop.redhat.io_quayecosystems_crd.yaml
oc apply -f operator.yaml

JSONPATH='{..status.conditions[0].status}'

while [[ $(kubectl get -f operator.yaml -o jsonpath=$JSONPATH) != "True" ]]
do echo "Waiting for quay operator to come up" && sleep 1
done

echo "Quay operator is up"