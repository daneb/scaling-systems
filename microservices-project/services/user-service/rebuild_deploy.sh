#!/bin/bash
# Script to rebuild and redeploy the user service

# Build new Docker image
echo "Building new Docker image..."
docker build -t user-service:latest .

# Deploy to Kubernetes (assumes you're using kubectl)
echo "Redeploying service to Kubernetes..."
kubectl rollout restart deployment user-service

echo "Done! Check logs with: kubectl logs -f deployment/user-service"
