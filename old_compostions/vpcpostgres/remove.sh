#!/bin/bash
oc delete -f requirement-aws.yaml
oc delete -f composition-aws-with-vpc.yaml
oc delete -f publication.yaml
oc delete -f definition.yaml
