#!/bin/bash
CONTAINER_ID=$(docker ps -q -f "name=openscad_local_development")
if [ -n "$CONTAINER_ID" ]; then
    docker cp ${CONTAINER_ID}:/openscad/build/openscad ./openscad/build/openscad
else
    echo "The openscad container needs to be running. It was not found."
fi