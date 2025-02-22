#!/bin/bash
# infrastructure/ci-cd/build-and-push.sh

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Function to build and push a service
build_and_push_service() {
    local service_name=$1
    local version=$2
    local registry_url="localhost:5000"

    echo -e "${GREEN}Building ${service_name}...${NC}"

    # Build the Docker image
    docker build -t ${registry_url}/${service_name}:${version} ./services/${service_name}

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Successfully built ${service_name}${NC}"

        # Push to local registry
        docker push ${registry_url}/${service_name}:${version}

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Successfully pushed ${service_name} to registry${NC}"
        else
            echo -e "${RED}Failed to push ${service_name} to registry${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Failed to build ${service_name}${NC}"
        exit 1
    fi
}
