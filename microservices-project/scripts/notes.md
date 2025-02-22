## Mongo Installation info

** Please be patient while the chart is being deployed **

MongoDB&reg; can be accessed on the following DNS name(s) and ports from within your cluster:

    mongodb.default.svc.cluster.local

To get the root password run:

    export MONGODB_ROOT_PASSWORD=$(kubectl get secret --namespace default mongodb -o jsonpath="{.data.mongodb-root-password}" | base64 -d)

To connect to your database, create a MongoDB&reg; client container:

    kubectl run --namespace default mongodb-client --rm --tty -i --restart='Never' --env="MONGODB_ROOT_PASSWORD=$MONGODB_ROOT_PASSWORD" --image docker.io/bitnami/mongodb:8.0.3-debian-12-r0 --command -- bash

Then, run the following command:
    mongosh admin --host "mongodb" --authenticationDatabase admin -u $MONGODB_ROOT_USER -p $MONGODB_ROOT_PASSWORD

To connect to your database from outside the cluster execute the following commands:

    kubectl port-forward --namespace default svc/mongodb 27017:27017 &
    mongosh --host 127.0.0.1 --authenticationDatabase admin -p $MONGODB_ROOT_PASSWORD

WARNING: There are "resources" sections in the chart not set. Using "resourcesPreset" is not recommended for production. For production installations, please set the following values according to your workload needs:
  - arbiter.resources
  - resources
+info https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

## View Addons
```sh
minikube addons list
```

## Create a registry
```sh
kubectl create namespace registry
kubectl apply -f infrastructure/registry/docker-registry.yaml
```

## Apply networking
```sh
kubectl apply -f infrastructure/networking/network-policies.yaml
kubectl apply -f infrastructure/networking/ingress-controller.yaml
```

## Enable Ingres
```sh
minikube addons enable ingress
```

## Registry port forwarding
```sh
kubectl port-forward --namespace registry svc/registry 5000:5000 &
```

## Registry port forwarding (push to registry)
```sh
kubectl port-forward --namespace kube-system service/registry 5000:80
```

## Set version number of image
```sh
kubectl set image deployment/user-service user-service=user-service:1.0.3
```

## Adding Traefik
```sh
kubectl repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik -n kube-system
```

## Check if Traefik is running
```sh
kubectl get pods -n kube-system | grep traefik
```

## Confirm Ingress is running
```sh
kubectl get ingress
```
