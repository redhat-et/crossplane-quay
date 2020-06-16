#!/bin/bash
oc delete -f requirement-aws.yaml
oc delete -f composition-aws-with-vpc.yaml
oc delete crd redisinstancerequirements.cache.example.org
oc delete crd redisinstances.cache.crossplane.io
oc delete crd redisinstances.cache.example.org
oc delete -f publication.yaml
oc delete -f definition.yaml
