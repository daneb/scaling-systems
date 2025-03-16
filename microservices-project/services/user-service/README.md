# User Service

## Very important: Local Docker registry
```sh
eval $(minikube docker-env)
```

1. First, create the MongoDB deployment:
```sh
# Add the bitnami repo if not already added
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install MongoDB
helm install mongodb bitnami/mongodb \
  --set auth.rootPassword=secretpassword
```

2. Build and deploy the user service:
```sh
# Build the Docker image
cd services/user-service
docker build -t user-service:1.0.0 .

# Create secrets
kubectl create secret generic user-service-secrets \
  --from-literal=mongodb-uri="mongodb://mongodb:27017/users" \
  --from-literal=jwt-secret="your-secret-key"

# Apply Kubernetes configurations
kubectl apply -f k8s/
```

3. Verify the deployment:
```sh
kubectl get pods
kubectl get services
```

## Troubleshooting

1. Ensure image is build in Minikube docker
```sh
eval $(minikube docker-env)
```

2. Rebuild the image
```sh
cd services/user-service
docker build -t user-service:1.0.0 .
minikube image load user-service:1.0.5
```

3. Tweak deployment.yaml
```yaml
spec:
  containers:
  - name: user-service
    image: user-service:1.0.0
    imagePullPolicy: Never  # Add this line to use local docker registry
```

4. Apply the changes
```sh
kubectl delete -f k8s/deployment.yaml  # Remove the old deployment
kubectl apply -f k8s/deployment.yaml   # Apply the new one
```

5. Check the logs
```sh
kubectl get pods
kubectl describe pod <pod-name>
```

6. Tar image to asses file contents
```sh
minikube image save user-service:1.0.5 user-service.tar
```

## Testing from within the Cluster

# From within the cluster (using a temporary debug pod)
```sh
kubectl run -i --tty --rm debug --image=curlimages/curl -- sh
# Then once inside the pod:
curl http://user-service/health

# OR using port-forward:
kubectl port-forward svc/user-service 8080:80

# Turn on the load-balancer to access your services via traefik
minikube tunnel

# Get load balancer IP
kubectl get service traefik

# Then in another terminal:
curl -H "Host: user-service.local" http://10.110.3.59/health
```
