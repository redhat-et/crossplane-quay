#!/bin/bash
oc delete -f requirement-aws.yaml
oc delete -f composition-aws-with-vpc.yaml
oc delete crd redisclusterrequirements.cache.example.org
oc delete crd redisclusters.cache.crossplane.io
oc delete crd redisclusters.cache.example.org
oc delete -f publication.yaml
oc delete -f definition.yaml
