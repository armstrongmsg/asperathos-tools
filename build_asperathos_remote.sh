#!/bin/bash

#
# Builds and deploys Asperathos in a remote instance.
# The remote instance must have a working docker-compose
# environment, using the asperathos-compose repository.
#

REMOTE_IP="$1"
REMOTE_KEY="$2"
#
# Filepath where the Asperathos Compose repository
# is placed in the remote instance.
#
COMPOSE_REMOTE_PATH="$3"
#
# Filepath where the Asperathos components code 
# is stored locally.
# 
LOCAL_ASPERATHOS_PATH="$4"

LOCAL_CONTROLLER_PATH="$LOCAL_ASPERATHOS_PATH/asperathos-controller"
LOCAL_MANAGER_PATH="$LOCAL_ASPERATHOS_PATH/asperathos-manager"
LOCAL_MONITOR_PATH="$LOCAL_ASPERATHOS_PATH/asperathos-monitor"
LOCAL_VISUALIZER_PATH="$LOCAL_ASPERATHOS_PATH/asperathos-visualizer"

scp -r -i $REMOTE_KEY $LOCAL_MANAGER_PATH ubuntu@$REMOTE_IP:$COMPOSE_REMOTE_PATH
scp -r -i $REMOTE_KEY $LOCAL_MONITOR_PATH ubuntu@$REMOTE_IP:$COMPOSE_REMOTE_PATH
scp -r -i $REMOTE_KEY $LOCAL_CONTROLLER_PATH ubuntu@$REMOTE_IP:$COMPOSE_REMOTE_PATH
scp -r -i $REMOTE_KEY $LOCAL_VISUALIZER_PATH ubuntu@$REMOTE_IP:$COMPOSE_REMOTE_PATH

ssh -i $REMOTE_KEY ubuntu@$REMOTE_IP << EOF 
	cd $COMPOSE_REMOTE_PATH
	export KUBECONFIG=/home/ubuntu/.kube/config
	./build.sh -l
	docker-compose up -d --force-recreate
EOF

