#!/bin/bash
source variables.env

cd configuration

oc delete configuration.pkg.crossplane.io/platform-quay

kubectl crossplane build configuration --name package.xpkg
kubectl crossplane push configuration ${PLATFORM_CONFIG} -f package.xpkg          
sleep 5
kubectl crossplane install configuration ${PLATFORM_CONFIG}
rm package.xpkg