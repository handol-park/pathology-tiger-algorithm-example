#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

SEGMENTATION_FILE="/output/images/breast-cancer-segmentation-for-tils/segmentation.tif"
DETECTION_FILE="/output/detected-lymphocytes.json"
TILS_SCORE_FILE="/output/til-score.json"

MEMORY=4g

echo "Building docker"
./build.sh

echo "Creating volume..."
docker volume create tiger-output

echo "Running algorithm..."
docker run --rm \
        --memory=$MEMORY \
        --memory-swap=$MEMORY \
        --network=none \
        --cap-drop=ALL \
        --security-opt="no-new-privileges" \
        --shm-size=128m \
        --pids-limit=256 \
        --gpus-all \
        -v $SCRIPTPATH/testinput/:/input/ \
        -v tiger-output:/output/ \
        tigerexamplealgorithm

echo "Checking output files..."
docker run --rm \
        -v tiger-output:/output/ \
        python:3.8-slim bash -c " \
        echo 'Validating JSON format of ${DETECTION_FILE}' && \
        python -m json.tool ${DETECTION_FILE} > /dev/null && \
        echo 'Checking for ${SEGMENTATION_FILE}' && test -f ${SEGMENTATION_FILE} && \
        echo 'Checking for ${TILS_SCORE_FILE}' && test -f ${TILS_SCORE_FILE} || \
        (echo 'Output file validation failed!' && exit 1)"

echo "Removing volume..."
docker volume rm tiger-output
