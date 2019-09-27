#!/bin/bash

#
# Requires a configuration file: nialm_monitor.cfg
#
# BROKER_IP=0.0.0.0
# BROKER_PORT=1500
# JOB_CONFIG_FILE="file1.json file2.json"
# NODES="IP1 IP2 IP3 IP4"
# OUTPUT_FILE="output.csv"
# REPS=1
#

function get_broker_status() {
  curl -s "http://$BROKER_IP:$BROKER_PORT/submissions/$1" | jq '.status' | sed -e 's/^"//' -e 's/"$//'
}

CONF_FILE="nialm_monitor.cfg"

source $CONF_FILE

for rep in $(seq 1 "$REPS")
do
  echo "Rep: $rep"
  for job in $JOB_CONFIG_FILE
  do
    echo "Running conf: $job"
    echo "Logging memory usage before application starts"
    for i in $(seq 1 10); do
      for NODE in $NODES; do
        used_mem="$(ssh -i ~/.ssh/scaling-cluster-key.pem ubuntu@"$NODE" free | awk '{ print $3 }' | awk 'FNR == 2 {print $1}')"
        echo "$rep","$job","$(date +%s)","$NODE","$used_mem" >>"$OUTPUT_FILE"
      done
      sleep 1
    done

    echo "Starting application"
    job_id="$(curl -s -H "Content-Type: application/json" --data @"$job" http://"$BROKER_IP":"$BROKER_PORT"/submissions)"
    # Get job_id from json
    job_id=$(echo "$job_id" | jq '.job_id')
    # Remove quotes
    job_id=$(echo "$job_id" | sed -e 's/^"//' -e 's/"$//')

    echo "Waiting application to start"
    while [ $(get_broker_status "$job_id") != "ongoing" ]; do
      sleep 1
    done

    echo "Collecting memory usage"
    while [ $(get_broker_status "$job_id") != "completed" ]; do
      for NODE in $NODES; do
        used_mem="$(ssh -i ~/.ssh/scaling-cluster-key.pem ubuntu@"$NODE" free | awk '{ print $3 }' | awk 'FNR == 2 {print $1}')"
        echo "$rep","$job","$(date +%s)","$NODE","$used_mem" >>"$OUTPUT_FILE"
      done
    done

    sleep 30
  done
done
