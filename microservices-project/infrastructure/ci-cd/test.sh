#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Function to run tests for a service
run_tests() {
    local service_name=$1

    echo -e "${GREEN}Running tests for ${service_name}...${NC}"

    # Change to service directory
    cd ./services/${service_name}

    # Run npm tests
    npm test

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Tests passed for ${service_name}${NC}"
    else
        echo -e "${RED}Tests failed for ${service_name}${NC}"
        exit 1
    fi

    cd ../..
}

# Check if a service name was provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Please provide a service name${NC}"
    echo "Usage: ./test.sh <service-name>"
    exit 1
fi

# Call the function with the provided service name
run_tests "$1"
