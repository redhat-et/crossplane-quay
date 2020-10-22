#!/bin/bash

source variables.env

oc create namespace crossplane-system

helm repo add crossplane-alpha https://charts.crossplane.io/alpha

helm install crossplane --namespace crossplane-system crossplane-alpha/crossplane --version 0.12.0

oc apply -f roles.yaml