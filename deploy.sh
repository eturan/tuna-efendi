#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to handle errors
error_exit() {
    echo "Error: $1" 1>&2
    exit 1
}

# Build the Docker image
docker build -t backstage-app . || error_exit "Failed to build Docker image"

# Stop and remove existing container if it exists
if [ "
$(docker ps -aq -f name=backstage-app)" ]; then
    docker stop backstage-app || error_exit "Failed to stop the existing container"
    docker rm backstage-app || error_exit "Failed to remove the existing container"
fi

# Run the new container
docker run -d --name backstage-app -p 7007:7007 backstage-app || error_exit "Failed to run the container"

echo "Backstage instance deployed successfully!"
