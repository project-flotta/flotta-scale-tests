#!/bin/bash
mkdir -p ${REGISTRATION_FOLDER}
mkdir -p ${GET_UPDATES_FOLDER}
mkdir -p ${HEARTBEAT_FOLDER}

touch ${REGISTRATION_FOLDER}/${DEVICE_ID}_register.out
touch ${REGISTRATION_FOLDER}/${DEVICE_ID}_register.err 
touch ${GET_UPDATES_FOLDER}/${DEVICE_ID}_get_updates.err
touch ${GET_UPDATES_FOLDER}/${DEVICE_ID}_get_updates.out
touch ${HEARTBEAT_FOLDER}/${DEVICE_ID}_heartbeat.out
touch ${HEARTBEAT_FOLDER}/${DEVICE_ID}_heartbeat.err