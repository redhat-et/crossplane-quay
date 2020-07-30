#!/bin/bash

cd $(dirname $0)

oc apply -f requirements/

seconds=0
until oc get secret bucket-conn > /dev/null 2>&1
do
echo "Waiting for S3 Bucket - $seconds seconds have passed"
sleep 5
seconds=`expr $seconds + 5`
done

echo "Bucket created"

seconds=0
until oc get secret db-conn > /dev/null 2>&1
do
echo "Waiting for Postgres Instance - $seconds seconds have passed"
sleep 5
seconds=`expr $seconds + 5`
done

echo "Postgres created"

seconds=0
until oc get secret redis-conn > /dev/null 2>&1
do
echo "Waiting for Redis Cluster - $seconds seconds have passed"
sleep 5
seconds=`expr $seconds + 5`
done

echo "Redis created"

# redis=$(oc get secret redis-conn -o jsonpath="{.data.endpoint}" | base64 --decode)
# postgres=$(oc get secret db-conn -o jsonpath="{.data.server}" | base64 --decode)
# echo "Postgres server: $postgres"
# echo "Redis instance: $redis"