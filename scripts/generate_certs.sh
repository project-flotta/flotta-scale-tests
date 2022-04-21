#!/bin/bash

# make get-certs
kubectl -n flotta get secrets flotta-ca --template="{{index .data \"ca.crt\" | base64decode}}" >${test_dir}/${DEVICE_ID}_ca.pem
export REG_SECRET_NAME=$(kubectl get secrets -n flotta -l reg-client-ca=true --sort-by=.metadata.creationTimestamp | tail -1 | awk '{print $1}')
kubectl -n flotta get secret ${REG_SECRET_NAME} --template="{{index .data \"client.crt\" | base64decode}}" > ${test_dir}/${DEVICE_ID}_cert.pem
kubectl -n flotta get secret ${REG_SECRET_NAME} --template="{{index .data \"client.key\" | base64decode}}" > ${test_dir}/${DEVICE_ID}_key.pem
# make get-certs END
