#!/usr/bin/env bash

# *********************
# Set useful variables
# *********************
CONTAINER_NAME="localstack"
LS_VERSION="4.14.0"
source .env # Contains the auth token

NETWORK="localstack-net"
SUBNET="172.20.0.0/16"
STATIC_IP="172.20.0.2" 

# **************************************
# Start localstack in podman (rootfull)
# **************************************

# Create the network first
sudo podman network exists $NETWORK || \
    sudo podman network create --subnet $SUBNET $NETWORK

# Start localstack with the proper values for ECS service
#
# Must use one of the following flags:
#   --privileged 
#   --security-opt label=disable 
# Otherwise, you will get the following error in the LS logs:
#  > MainThread] l.u.c.docker_sdk_client : Creating Docker SDK client 
#  > failed: Error while fetching server API version: 
#  > ('Connection aborted.', PermissionError(13, 'Permission denied')). 
#  > If you want to use Docker as container runtime, make sure to mount 
#  > the socket at /var/run/docker.sock
#  
# See: 
# - https://github.com/coreos/fedora-coreos-tracker/issues/585
# - https://github.com/containers/podman/discussions/14238#discussioncomment-2746414
# docker run -d --rm \
sudo podman run -d --rm \
	--privileged \
	--name $CONTAINER_NAME \
	--network $NETWORK \
	--ip $STATIC_IP \
	-p 4566:4566 \
	-p 4510-4559:4510-4559 \
    -e LS_LOG=trace \
	-e LOCALSTACK_AUTH_TOKEN="$LOCALSTACK_AUTH_TOKEN" \
	-e ECR_ENDPOINT_STRATEGY=off \
    -e LAMBDA_DOCKER_DNS="$STATIC_IP" \
    -e LAMBDA_DOCKER_NETWORK="$NETWORK" \
    -e LAMBDA_DOCKER_FLAGS="--priviledged" \
	-e DEBUG=0 \
	-e ECS_DOCKER_FLAGS="--network=$NETWORK --dns=$STATIC_IP" \
	-v /var/run/docker.sock:/var/run/docker.sock \
	localstack/localstack-pro:$LS_VERSION

    # -e ECS_REMOVE_CONTAINERS=0 \
