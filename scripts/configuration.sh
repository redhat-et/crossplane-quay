#!/bin/bash
source variables.env

kubectl crossplane install configuration ${PLATFORM_CONFIG}
