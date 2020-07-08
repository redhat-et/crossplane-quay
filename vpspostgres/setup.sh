#!/bin/bash
oc apply -f definition.yaml
sleep 8
oc apply -f publication.yaml
sleep 8
oc apply -f composition-aws-with-vpc.yaml
sleep 8
oc apply -f requirement-aws.yaml
