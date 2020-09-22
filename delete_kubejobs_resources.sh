#!/bin/bash

#
# Deletes all the pods associated with 
# a given Asperathos job id
#

#
# The job id
# 
JOB_ID="$1"
#
# Kubernetes configuration filepath
#
CONFIG_FILE="$2"

kubectl --kubeconfig=$CONFIG_FILE delete job $JOB_ID
kubectl --kubeconfig=$CONFIG_FILE delete services grafana-$JOB_ID influxdb-$JOB_ID redis-$JOB_ID
kubectl --kubeconfig=$CONFIG_FILE delete pods grafana-$JOB_ID influxdb-$JOB_ID redis-$JOB_ID
