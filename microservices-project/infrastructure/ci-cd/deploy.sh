# infrastructure/ci-cd/deploy.sh
#!/bin/bash

# Function to deploy a service
deploy_service() {
    local service_name=$1
    local version=$2

    echo -e "${GREEN}Deploying ${service_name}...${NC}"

    # Apply Kubernetes configurations
    kubectl apply -f ./services/${service_name}/k8s/

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Successfully deployed ${service_name}${NC}"

        # Wait for deployment to be ready
        kubectl rollout status deployment/${service_name}

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Deployment of ${service_name} is ready${NC}"
        else
            echo -e "${RED}Deployment of ${service_name} failed${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Failed to apply Kubernetes configurations for ${service_name}${NC}"
        exit 1
    fi
}
