#!/bin/bash

if [ -z ${IMAGE+x} ]; then
    echo "Warning: IMAGE not set, using default"
    export IMAGE=ghcr.io/autonomous-testing/wopee:latest
fi
echo "IMAGE: $IMAGE"

if [ -z ${CONFIG+x} ]; then
    echo "Warning: CONFIG not set, using default"
    export CONFIG=config.yaml
fi
echo "CONFIG: $CONFIG"

if [ -f $CONFIG ]; then
    echo "File '$CONFIG' does exist localy and will be used."
    export LOCAL_CONFIG_MOUNT=$(pwd)/$CONFIG
    export CONTAINER_CONFIG_MOUNT=/home/wopee/$CONFIG
else
    echo "File '$CONFIG' does not exist localy and will be downloaded."
    export LOCAL_CONFIG_MOUNT=$(pwd)
    export CONTAINER_CONFIG_MOUNT=/home/wopee/pwd
fi

if [ -z ${SECCOMP_PROFILE+x} ]; then
    echo "Warning: SECCOMP_PROFILE not set, using default"
    export SECCOMP_PROFILE=seccomp_profile.json
fi
echo "SECCOMP_PROFILE: $SECCOMP_PROFILE"

docker pull ${IMAGE}

echo "# Runner env:"
echo "#############"
echo

env

echo
echo

    # --env-file <(env | sed '/^PATH=/d') \
echo "# Docker env:"
echo "#############"
echo
docker run --rm \
    -v $LOCAL_CONFIG_MOUNT:$CONTAINER_CONFIG_MOUNT:ro \
    --ipc=host \
    --network=host \
    --security-opt seccomp=$SECCOMP_PROFILE \
    ${IMAGE} env
