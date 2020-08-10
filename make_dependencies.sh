#!/bin/bash

cd $(dirname $0)

oc apply -f helm/output/quay-cp/templates/requirements.yaml

seconds=0
until oc get secret bucket-conn > /dev/null 2>&1
do
echo "Waiting for S3 Bucket - $seconds seconds have passed"
sleep 5
seconds=`expr $seconds + 5`
done

echo "Bucket created"

until oc get secret db-conn > /dev/null 2>&1
do
echo "Waiting for Postgres Instance - $seconds seconds have passed"
sleep 5
seconds=`expr $seconds + 5`
done

echo "Postgres created"

until oc get secret redis-conn > /dev/null 2>&1
do
echo "Waiting for Redis Cluster - $seconds seconds have passed"
sleep 5
seconds=`expr $seconds + 5`
done

echo "Redis created"
