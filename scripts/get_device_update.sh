#!/bin/bash

echo "curl -XGET \\
  --cacert ${CERTS_FOLDER}/default_ca.pem \\
  --cert ${CERTS_FOLDER}/${DEVICE_ID}.pem \\
  --key ${CERTS_FOLDER}/${DEVICE_ID}.key -v \\
  -H \"Content-Type: application/json\" \\
  -H \"Cache-Control: no-cache\" \\
  https://${HTTP_SERVER}:${HTTP_SERVER_PORT}/${REQUEST_PATH}"

curl -XGET \
  --cacert ${CERTS_FOLDER}/default_ca.pem \
  --cert ${CERTS_FOLDER}/${DEVICE_ID}.pem \
  --key ${CERTS_FOLDER}/${DEVICE_ID}.key -v \
  -H "Content-Type: application/json" \
  -H "Cache-Control: no-cache" \
  https://${HTTP_SERVER}:${HTTP_SERVER_PORT}/${REQUEST_PATH}

if [ $? -ne 0 ]; then
  echo "Error getting device updates"
  exit -1
fi;

exit 0
