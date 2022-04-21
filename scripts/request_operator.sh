#!/bin/bash

echo "curl -XPOST \\
  --cacert ${test_dir}/default_ca.pem \\
  --cert ${test_dir}/${DEVICE_ID}.pem \\
  --key ${test_dir}/${DEVICE_ID}.key -v \\
  -H \"Content-Type: application/json\" \\
  --data ${POST_BODY} \\
  https://${HTTP_SERVER}:${HTTP_SERVER_PORT}/${REQUEST_PATH}"

curl -XPOST \
  --cacert ${test_dir}/default_ca.pem \
  --cert ${test_dir}/${DEVICE_ID}.pem \
  --key ${test_dir}/${DEVICE_ID}.key -v \
  -H "Content-Type: application/json" \
  --data ${POST_BODY} \
  https://${HTTP_SERVER}:${HTTP_SERVER_PORT}/${REQUEST_PATH}

if [ $? -ne 0 ]; then
  echo "Error posting device"
  exit -1
fi;

exit 0
