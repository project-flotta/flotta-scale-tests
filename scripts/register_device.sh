#!/bin/bash 
openssl ecparam -name prime256v1 -genkey -noout -out ${test_dir}/${DEVICE_ID}.key
openssl req -new -subj '/CN=${DEVICE_ID}' -key ${test_dir}/${DEVICE_ID}.key -out ${test_dir}/${DEVICE_ID}.csr
export CERTIFICATE_REQUEST=$(cat ${test_dir}/${DEVICE_ID}.csr | sed 's/$/\\n/' | tr -d '\n')
UUID=$(uuidgen)
echo "${PAYLOAD}" | sed -e 's/"content": {/"content": {\n       "certificate_request": "$CERTIFICATE_REQUEST",/g' | envsubst > ${test_dir}/${DEVICE_ID}_payload.json

#Verify!
cat ${test_dir}/${DEVICE_ID}_payload.json | jq .

if [ $? -ne 0 ]; then
 echo "Error when checking ${test_dir}/${DEVICE_ID}_payload.json"
 exit -1
fi
echo "curl \
  --cacert ${test_dir}/default_ca.pem \\
  --cert ${test_dir}/default_cert.pem \\
  --key ${test_dir}/default_key.pem -v \\
  -d @${test_dir}/${DEVICE_ID}_payload.json \\
  -X POST \\
  -H \"Content-Type: application/json\" \
  -o ${test_dir}/${DEVICE_ID}_response.json \\
  https://${HTTP_SERVER}:${HTTP_SERVER_PORT}/api/flotta-management/v1/data/${DEVICE_ID}/out"

curl \
  --cacert ${test_dir}/default_ca.pem \
  --cert ${test_dir}/default_cert.pem \
  --key ${test_dir}/default_key.pem -v \
  -d @${test_dir}/${DEVICE_ID}_payload.json \
  -X POST \
  -H "Content-Type: application/json" \
  -o ${test_dir}/${DEVICE_ID}_response.json \
  https://${HTTP_SERVER}:${HTTP_SERVER_PORT}/api/flotta-management/v1/data/${DEVICE_ID}/out 
if [ $? -ne 0 ]; then
 echo "Error when sending registration request, see  ${test_dir}/${DEVICE_ID}_register.out"
 exit -1
fi

cat ${test_dir}/${DEVICE_ID}_response.json | jq '.content.certificate' | sed -e 's/\\n/\n/g' | sed -e 's/"//g' > ${test_dir}/${DEVICE_ID}.pem


#openssl x509 -in ${test_dir}/${DEVICE_ID}.pem --text

if [ $? -ne 0 ]; then
 echo "Error when extracting ${test_dir}/${DEVICE_ID}_response.json to  ${test_dir}/${DEVICE_ID}.pem"
 exit -1
fi

exit 0

