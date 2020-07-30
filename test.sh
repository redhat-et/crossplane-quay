#!/bin/bash

source variables.env

oc apply -f compositions/

oc get crd bucketrequirements.storage.example.org