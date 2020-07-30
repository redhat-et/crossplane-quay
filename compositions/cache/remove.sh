#!/bin/bash
cd $(dirname $0)
oc delete -f composition-aws-with-vpc.yaml
oc delete -f publication.yaml
oc delete -f definition.yaml
