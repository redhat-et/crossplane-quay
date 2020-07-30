#!/bin/bash
cd $(dirname $0)
oc delete -f composition-aws.yaml
oc delete -f publication.yaml
oc delete -f definition.yaml
