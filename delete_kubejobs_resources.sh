#!/bin/bash

CONFIG_FILE="/home/armstrong/Documents/kubernetes/config_k8s_scaling"
JOB_ID="$1"

kubectl --kubeconfig=$CONFIG_FILE delete job $JOB_ID
kubectl --kubeconfig=$CONFIG_FILE delete services grafana-$JOB_ID influxdb-$JOB_ID redis-$JOB_ID
kubectl --kubeconfig=$CONFIG_FILE delete pods grafana-$JOB_ID influxdb-$JOB_ID redis-$JOB_ID
