#!/bin/bash
oc get crds -o name | grep crossplane | sed 's/.*\///' | xargs -n1 oc get -n crossplane-system -o name | xargs oc patch -n crossplane-system -p '{"metadata":{"finalizers":[]}}' --type=merge
