#!/bin/bash

#
# Deletes all pods and services associated with
# Asperathos support components (Influx DB, Grafana, Redis),
# normally used on cleanups after faulty executions.
# 

KUBE_CONF_FILE=$1

services=`kubectl --kubeconfig=$KUBE_CONF_FILE get services | awk '{print $1}' | grep -E "influx|grafana|redis"`

pods=`kubectl --kubeconfig=$KUBE_CONF_FILE get pods | awk '{print $1}' | grep -E "influx|grafana|redis"`

kubectl --kubeconfig=$KUBE_CONF_FILE delete services $services
kubectl --kubeconfig=$KUBE_CONF_FILE delete pods $pods

