#!/bin/bash
source variables.env

cd configuration

kubectl delete configuration.pkg.crossplane.io/krishchow-platform-quay

kubectl crossplane build configuration --name package.xpkg
kubectl crossplane push configuration ${PLATFORM_CONFIG} -f package.xpkg          
sleep 5
rm package.xpkg