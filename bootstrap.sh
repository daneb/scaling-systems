#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to create a directory and print status
create_directory() {
    echo -e "${BLUE}Creating directory:${NC} $1"
    mkdir -p "$1"
}

# Function to create a file with content
create_file() {
    local file_path="$1"
    local content="$2"
    echo -e "${BLUE}Creating file:${NC} $file_path"
    echo -e "$content" > "$file_path"
}

# Main project setup
main() {
    # Get project name from user or use default
    read -p "Enter project name (default: microservices-project): " PROJECT_NAME
    PROJECT_NAME=${PROJECT_NAME:-microservices-project}

    # Create base directory
    create_directory "$PROJECT_NAME"
    cd "$PROJECT_NAME"

    # Documentation structure
    create_directory "docs/architecture/ADR"
    create_directory "docs/architecture/diagrams"
    create_directory "docs/architecture/api-specs"
    create_directory "docs/runbooks"
    create_directory "docs/learning-resources"

    # Infrastructure structure
    create_directory "infrastructure/kubernetes"
    create_directory "infrastructure/istio"
    create_directory "infrastructure/observability"

    # Services structure
    create_directory "services/api-gateway"
    create_directory "services/user-service"
    create_directory "services/product-service"
    create_directory "services/order-service"

    # Scripts directory
    create_directory "scripts"

    # Create basic README files
    create_file "README.md" "# $PROJECT_NAME\n\nMicroservices development project for learning and exploration.\n\n## Project Structure\n\nThis project follows a structured approach to microservices development.\n\n## Getting Started\n\n1. Install required tools\n2. Set up local environment\n3. Follow the learning path\n\n## Documentation\n\nSee the /docs directory for detailed documentation."

    create_file "docs/architecture/ADR/README.md" "# Architecture Decision Records\n\nThis directory contains Architecture Decision Records (ADRs) for the project.\n\n## What are ADRs?\n\nADRs are documents that capture important architectural decisions made along with their context and consequences."

    create_file "docs/architecture/ADR/0001-record-architecture-decisions.md" "# 1. Record Architecture Decisions\n\nDate: $(date +%Y-%m-%d)\n\n## Status\n\nAccepted\n\n## Context\n\nWe need to record the architectural decisions made on this project.\n\n## Decision\n\nWe will use Architecture Decision Records, as described by Michael Nygard in this article: http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions\n\n## Consequences\n\nSee Michael Nygard's article, linked above."

    # Create basic kubernetes configuration
    create_file "infrastructure/kubernetes/README.md" "# Kubernetes Configurations\n\nThis directory contains Kubernetes manifests and configurations.\n\n## Directory Structure\n\n- base/: Base configurations\n- overlays/: Environment-specific configurations"

    # Create basic service readmes
    create_file "services/api-gateway/README.md" "# API Gateway Service\n\nThis service handles routing and authentication for the microservices architecture."
    create_file "services/user-service/README.md" "# User Service\n\nHandles user management and authentication."
    create_file "services/product-service/README.md" "# Product Service\n\nManages product catalog and inventory."
    create_file "services/order-service/README.md" "# Order Service\n\nHandles order processing and management."

    # Create basic script files
    create_file "scripts/setup-environment.sh" "#!/bin/bash\n\necho 'Setting up development environment...'\n# Add environment setup commands here"
    chmod +x scripts/setup-environment.sh

    # Create .gitignore
    create_file ".gitignore" "# IDE files
.idea/
.vscode/

# Dependencies
node_modules/
vendor/

# Compiled files
*.class
*.jar
*.war
*.ear

# Logs
*.log
logs/

# Environment variables
.env
.env.*

# Operating System
.DS_Store
Thumbs.db

# Kubernetes
kubeconfig
*.kubeconfig

# Other
*.swp
*.swo"

    # Initialize git repository
    echo -e "${BLUE}Initializing git repository...${NC}"
    git init
    git add .
    git commit -m "Initial project structure"

    echo -e "${GREEN}Project structure created successfully!${NC}"
    echo -e "${GREEN}Project initialized at: $(pwd)${NC}"
    echo -e "\n${BLUE}Next steps:${NC}"
    echo "1. cd $PROJECT_NAME"
    echo "2. Review the README.md file"
    echo "3. Start with environment setup using scripts/setup-environment.sh"
}

# Run the main function
main
