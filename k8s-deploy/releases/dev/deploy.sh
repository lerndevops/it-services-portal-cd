#!/bin/bash

set -e

MANIFEST_FILE=$1
IMAGE_TAG=$2

if [ -z "$MANIFEST_FILE" ] || [ -z "$IMAGE_TAG" ]; then
    echo "Usage: $0 <manifest-file> <image-tag>"
    echo "Example: $0 deployment.yml 123"
    exit 1
fi

sed -i "s|image: lerndevops/it-services-portal:.*|image: lerndevops/it-services-portal:${IMAGE_TAG}|g" "$MANIFEST_FILE"

echo "Updated image tag to ${IMAGE_TAG}"

echo " deploying the application to kubernetes"
kubectl apply -f . 
