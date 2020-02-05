#!/bin/bash

KUBE_CONF_FILE=$1

services=`kubectl --kubeconfig=$KUBE_CONF_FILE get services | awk '{print $1}' | grep -E "influx|grafana"`

pods=`kubectl --kubeconfig=$KUBE_CONF_FILE get pods | awk '{print $1}' | grep -E "influx|grafana"`

kubectl --kubeconfig=$KUBE_CONF_FILE delete services $services
kubectl --kubeconfig=$KUBE_CONF_FILE delete pods $pods
