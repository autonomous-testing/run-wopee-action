#!/bin/bash

if [ -z ${IMAGE+x} ]; then
    echo "Warning: IMAGE not set, using default"
    export IMAGE=ghcr.io/autonomous-testing/wopee:latest
fi
echo "IMAGE: $IMAGE"

if [ -z ${CONTAINER_NAME+x} ]; then
    echo "Warning: CONTAINER_NAME not set, using default"
    export CONTAINER_NAME=wopee-runner
fi
echo "CONTAINER_NAME: $CONTAINER_NAME"

if [ -z ${CONFIG+x} ]; then
    echo "Warning: CONFIG not set, using default"
    export CONFIG=config.yaml
fi
echo "CONFIG: $CONFIG"

if [ -f $CONFIG ]; then
    echo "File '$CONFIG' exists localy and will be used."
    export LOCAL_CONFIG_MOUNT=$(pwd)/$CONFIG
    export CONTAINER_CONFIG_MOUNT=/home/wopee/$CONFIG
else
    echo "File '$CONFIG' does not exist localy and will be downloaded."
    export LOCAL_CONFIG_MOUNT=$(pwd)
    export CONTAINER_CONFIG_MOUNT=/home/wopee/pwd
fi

if [ -f $ENV_FILE ]; then
    echo "File '$ENV_FILE' exists localy and will be used."
else
    echo "Warning: File '$ENV_FILE' does not exist."
    echo "ENV_FILE_NOT_SET=true" > .env_file_not_set.env
    export ENV_FILE=.env_file_not_set.env
fi
echo "ENV_FILE: $ENV_FILE"

if [ -z ${SECCOMP_PROFILE+x} ]; then
    echo "Warning: SECCOMP_PROFILE not set, using default"
    export SECCOMP_PROFILE=seccomp_profile.json
fi
echo "SECCOMP_PROFILE: $SECCOMP_PROFILE"

docker ps -q --filter "name=$CONTAINER_NAME" | grep -q . && docker stop $CONTAINER_NAME

docker pull ${IMAGE}

docker run --rm \
    --name $CONTAINER_NAME \
    -v $LOCAL_CONFIG_MOUNT:$CONTAINER_CONFIG_MOUNT:ro \
    --env-file <(env | sed '/^PATH=/d;/^HOME=/d;/^USER=/d;/^_=/d') \
    --env-file $ENV_FILE \
    --ipc=host \
    --network=host \
    --security-opt seccomp=$SECCOMP_PROFILE \
    ${IMAGE}
