#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <device_id> <test_run_dir>"
    exit 1
fi

if [ ! -d "$2" ]; then
    echo "Test run directory $2 does not exist"
    exit 1
fi

DEVICE_ID=$1
TEST_RUN_DIR=$2

DEVICE_KEY_FILE=$TEST_RUN_DIR/certs/$DEVICE_ID.key
openssl ecparam -name prime256v1 -genkey -noout -out $DEVICE_KEY_FILE
openssl req -new -subj '/CN=$DEVICEID' -key $DEVICE_KEY_FILE -out $TEST_RUN_DIR/certs/$DEVICE_ID.csr

