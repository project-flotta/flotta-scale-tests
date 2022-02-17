#!/bin/bash

kubectl get edgedevices --all-namespaces --no-headers | awk '{print $2 " --namespace=" $1}' |  xargs -n 2 kubectl patch edgedevice -p '{"metadata":{"finalizers":null}}' --type=merge
kubectl get edgedeployment --all-namespaces --no-headers | awk '{print $2 " --namespace=" $1}' | xargs -n 2 kubectl patch edgedeployment -p '{"metadata":{"finalizers":null}}' --type=merge
kubectl delete edgedevice --all --all-namespaces
kubectl delete edgedeployments --all --all-namespaces

if [ $# -eq 1 ]; then
    for i in $(seq $1)
    do
      kubectl delete ns $((i - 1))
    done
fi
