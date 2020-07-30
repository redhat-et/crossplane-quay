#!/bin/bash

cd $(dirname $0)

oc delete -f requirements/

# redis=$(oc get secret redis-conn -o jsonpath="{.data.endpoint}" | base64 --decode)
# postgres=$(oc get secret db-conn -o jsonpath="{.data.server}" | base64 --decode)
# echo "Postgres server: $postgres"
# echo "Redis instance: $redis"