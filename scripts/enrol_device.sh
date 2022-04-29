#!/bin/bash

echo "${PAYLOAD}" |  envsubst > ${ENROL_FOLDER}/${DEVICE_ID}_enrol_payload.json

#Verify!
cat ${ENROL_FOLDER}/${DEVICE_ID}_enrol_payload.json | jq .

if [ $? -ne 0 ]; then
 echo "Error when checking ${ENROL_FOLDER}/${DEVICE_ID}_enrol_payload.json"
 exit -1
fi
echo "curl \
  --cacert ${CERTS_FOLDER}/default_ca.pem \\
  --cert ${CERTS_FOLDER}/default_cert.pem \\
  --key ${CERTS_FOLDER}/default_key.pem -v \\
  -d @${ENROL_FOLDER}/${DEVICE_ID}_enrol_payload.json \\
  -X POST \\
  -H \"Content-Type: application/json\" \
  -i \\
  https://${HTTP_SERVER}:${HTTP_SERVER_PORT}/api/flotta-management/v1/data/${DEVICE_ID}/out > ${ENROL_FOLDER}/${DEVICE_ID}_enrol_response.json"

curl \
  --cacert ${CERTS_FOLDER}/default_ca.pem \
  --cert ${CERTS_FOLDER}/default_cert.pem \
  --key ${CERTS_FOLDER}/default_key.pem -v \
  -d @${ENROL_FOLDER}/${DEVICE_ID}_enrol_payload.json \
  -X POST \
  -H "Content-Type: application/json" \
  -i \
  https://${HTTP_SERVER}:${HTTP_SERVER_PORT}/api/flotta-management/v1/data/${DEVICE_ID}/out > ${ENROL_FOLDER}/${DEVICE_ID}_enrol_response.json

if [ $? -ne 0 ]; then
 echo "Error when sending enrol request, see  ${ENROL_FOLDER}/${DEVICE_ID}_enrol.out"
 exit -1
fi

cat ${ENROL_FOLDER}/${DEVICE_ID}_enrol_response.json | grep 208 > /dev/null
if [ $? -eq 0 ]; then
  echo "Device ${DEVICE_ID} already enroled"
  exit -1
else
  cat ${ENROL_FOLDER}/${DEVICE_ID}_enrol_response.json | grep 200 > /dev/null
  if [ $? -ne 0 ]; then
    echo "Error when sending enrol request, see  ${ENROL_FOLDER}/${DEVICE_ID}_enrol_response.json"
    exit -1
  fi
fi

exit 0