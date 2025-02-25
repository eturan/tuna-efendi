#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Default deployment type
DEPLOY_TYPE="docker"

# Function to handle errors
error_exit() {
    echo "Error: $1" 1>&2
    exit 1
}

# Function to print usage
usage() {
    echo "Usage: $0 [-t deployment_type]"
    echo "  deployment_type: 'docker' or 'kubernetes' (default: docker)"
    exit 1
}

# Parse command line arguments
while getopts "t:" opt; do
    case $opt in
        t)
            DEPLOY_TYPE=$OPTARG
            ;;
        \?)
            usage
            ;;
    esac
done

# Build the Docker image
echo "Building Docker image..."
docker build -t backstage-app . || error_exit "Failed to build Docker image"

if [ "$DEPLOY_TYPE" = "docker" ]; then
    echo "Deploying with Docker..."
    
    # Stop and remove existing container if it exists
    if [ "$(docker ps -aq -f name=backstage-app)" ]; then
        docker stop backstage-app || error_exit "Failed to stop the existing container"
        docker rm backstage-app || error_exit "Failed to remove the existing container"
    fi

    # Run the new container
    docker run -d --name backstage-app -p 7007:7007 backstage-app || error_exit "Failed to run the container"

    echo "Backstage instance deployed successfully with Docker!"

elif [ "$DEPLOY_TYPE" = "kubernetes" ]; then
    echo "Deploying with Kubernetes..."
    
    # Check if kubectl is installed
    if ! command -v kubectl &> /dev/null; then
        error_exit "kubectl is not installed"
    fi

    # Check if Kubernetes cluster is accessible
    kubectl cluster-info || error_exit "Failed to connect to Kubernetes cluster"

    # Apply Kubernetes manifests
    kubectl apply -f k8s/backstage-deployment.yaml || error_exit "Failed to apply deployment"
    kubectl apply -f k8s/backstage-service.yaml || error_exit "Failed to apply service"

    # Wait for deployment to be ready
    echo "Waiting for deployment to be ready..."
    kubectl rollout status deployment/backstage || error_exit "Deployment failed"

    echo "Backstage instance deployed successfully with Kubernetes!"
else
    error_exit "Invalid deployment type: $DEPLOY_TYPE. Use 'docker' or 'kubernetes'"
fi
