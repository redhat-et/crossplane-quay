#!/bin/bash
oc apply -f definition.yaml
oc apply -f publication.yaml
oc apply -f composition-aws.yaml
oc apply -f requirement-aws.yaml
