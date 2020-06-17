#!/bin/bash
oc delete -f requirement-aws.yaml
oc delete -f composition-aws.yaml
oc delete crd bucketrequirements.storage.example.org
oc delete crd buckets.storage.example.org
oc delete crd buckets.storage.example.org
oc delete -f publication.yaml
oc delete -f definition.yaml
