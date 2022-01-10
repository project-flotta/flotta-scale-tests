#!/bin/bash

kubectl get edgedevice  -o=custom-columns=NAME:.metadata.name --no-headers | xargs kubectl patch edgedevice -p '{"metadata":{"finalizers":null}}' --type=merge
kubectl get edgedeployment -o=custom-columns=NAME:.metadata.name --no-headers | xargs kubectl patch edgedeployment -p '{"metadata":{"finalizers":null}}' --type=merge
oc delete edgedevice --all
oc delete edgedeployments --all
oc delete obc --all
