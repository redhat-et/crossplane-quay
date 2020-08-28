#!/bin/bash

oc apply -f helm/output/quay-cp/templates/compositions

echo "Waiting for CR - bucket"
until oc get crd bucketrequirements.storage.example.org
do sleep 1
done

echo "Waiting for CR - db"
until oc get crd postgresqlinstancerequirements.database.example.org
do sleep 1
done

echo "Waiting for CR - redis"
until oc get crd redisclusterrequirements.cache.example.org
do sleep 1
done

echo "Waiting for CR - network"
until oc get crd networkgrouprequirements.ec2.example.org
do sleep 1
done