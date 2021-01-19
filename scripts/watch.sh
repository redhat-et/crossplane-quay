#!/bin/bash

watch 'kubectl get subnets,\
securitygroup,\
routetable,\
iamuser,\
iamaccesskey,\
bucket,\
bucketpolicy,\
cachesubnetgroup,\
replicationgroup,\
dbsubnetgroup,\
rdsinstance,\
operator,\
release -o custom-columns-file="scripts/template.txt" | column -t'