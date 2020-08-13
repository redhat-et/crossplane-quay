#!/bin/bash

source variables.env

cd $(dirname $0)

oc apply -f helm/output/quay-cp/templates/requirements.yaml

seconds=0
until oc get secret $S3SECRET -n $NAMESPACE > /dev/null 2>&1
do
echo "Waiting for S3 Bucket - $seconds seconds have passed"
sleep 5
seconds=`expr $seconds + 5`
done

echo "Bucket created"


if [ "$EXTERNALREDIS" = true ]; then
until oc get secret $REDISSECRET -n $NAMESPACE > /dev/null 2>&1
do
echo "Waiting for Redis Cluster - $seconds seconds have passed"
sleep 5
seconds=`expr $seconds + 5`
done

echo "Redis created"
fi

until oc get secret $DBSECRET -n $NAMESPACE > /dev/null 2>&1
do
echo "Waiting for Postgres Instance - $seconds seconds have passed"
sleep 5
seconds=`expr $seconds + 5`
done

echo "Postgres created"
