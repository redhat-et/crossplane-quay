#!/bin/bash

./compositions/setup.sh

echo "Waiting for CR - bucket"
until oc get crd bucketrequirements.storage.example.org > /dev/null
do sleep 1
done

echo "Waiting for CR - db"
until oc get crd postgresqlinstancerequirements.database.example.org > /dev/null
do sleep 1
done

echo "Waiting for CR - redis"
until oc get crd redisclusterrequirements.cache.example.org > /dev/null
do sleep 1
done


./make_dependencies.sh