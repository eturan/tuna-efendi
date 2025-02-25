# Backstage Deployment Procedure

## Overview
This document outlines the automated procedure for deploying and updating a Backstage instance using either Docker or Kubernetes. The procedure includes error handling to ensure the installation remains in a working state during updates.

## Prerequisites
- Docker installed on your machine
- For Kubernetes deployment:
  - kubectl installed
  - Access to a Kubernetes cluster
  - Basic knowledge of Kubernetes concepts
- Basic knowledge of command line operations

## Local Testing with Docker
1. **Build and run locally**:
   ```bash
   ./deploy.sh -t docker
   ```
2. **Access the application**:
   Open your browser and navigate to `http://localhost:7007`

## Kubernetes Deployment
1. **Ensure your Kubernetes cluster is accessible**:
   ```bash
   kubectl cluster-info
   ```

2. **Deploy to Kubernetes**:
   ```bash
   ./deploy.sh -t kubernetes
   ```

3. **Access the application**:
   The service is exposed as ClusterIP by default. To access it, you can either:
   - Set up an Ingress controller
   - Use port-forwarding:
     ```bash
     kubectl port-forward svc/backstage 7007:7007
     ```

## Deployment Architecture
- **Docker**: Runs as a single container with port 7007 exposed
- **Kubernetes**: 
  - Deployment with rolling update strategy
  - Service of type ClusterIP
  - Health checks via readiness and liveness probes
  - Resource limits and requests defined

## Error Handling
The deployment script includes comprehensive error handling for both Docker and Kubernetes deployments:
- Validates deployment type
- Checks for required tools
- Ensures clean deployment state
- Verifies deployment success
- Rolls back automatically on failure

## Troubleshooting
### Docker
- Check container logs: `docker logs backstage-app`
- Check container status: `docker ps -a`

### Kubernetes
- Check pod status: `kubectl get pods -l app=backstage`
- Check pod logs: `kubectl logs -l app=backstage`
- Check deployment status: `kubectl describe deployment backstage`
