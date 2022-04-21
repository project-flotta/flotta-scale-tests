#!/bin/bash

echo "curl -XGET \\
  --cacert ${test_dir}/default_ca.pem \\
  --cert ${test_dir}/${DEVICE_ID}.pem \\
  --key ${test_dir}/${DEVICE_ID}.key -v \\
  -H \"Content-Type: application/json\" \\
  -H \"Cache-Control: no-cache\" \\
  https://${HTTP_SERVER}:${HTTP_SERVER_PORT}/${REQUEST_PATH}"

curl -XGET \
  --cacert ${test_dir}/default_ca.pem \
  --cert ${test_dir}/${DEVICE_ID}.pem \
  --key ${test_dir}/${DEVICE_ID}.key -v \
  -H "Content-Type: application/json" \
  -H "Cache-Control: no-cache" \
  https://${HTTP_SERVER}:${HTTP_SERVER_PORT}/${REQUEST_PATH}

if [ $? -ne 0 ]; then
  echo "Error getting device updates"
  exit -1
fi;

exit 0
