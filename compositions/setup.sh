#!/bin/bash
cd $(dirname $0)
oc apply -f bucket/
oc apply -f cache/
oc apply -f database/
