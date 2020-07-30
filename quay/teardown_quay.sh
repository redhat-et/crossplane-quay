#!/bin/bash
cd $(dirname $0)

oc delete -f operator.yaml
oc delete -f redhatcop.redhat.io_quayecosystems_crd.yaml
oc delete -f RBAC/role_binding.yaml
oc delete -f RBAC/role.yaml
oc delete -f RBAC/service_account.yaml
oc delete -f pull.yaml
