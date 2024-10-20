#!/bin/bash

# Switch to the Docker starter-kit directory
cd /opt/kickstart-docker || { echo "Directory /opt/kickstart-docker not found. Exiting."; exit 1; }

# Function to check Docker login status
check_docker_login() {
    if ! sudo docker info | grep -q "Username:"; then
        echo "You are not logged in to Docker Hub."
        echo "Please log in to Docker Hub first."
        sudo docker login
        if [ $? -ne 0 ]; then
            echo "Docker login failed. Exiting."
            exit 1
        fi
    else
        echo "You are already logged in to Docker Hub."
    fi
}

# Function to build and push a Docker image
build_and_push_image() {
    local service=$1
    local version=$2
    local image_name="eliyaser/${service}:v${version}"
    local dockerfile_path="image/${service}/${version}/amazon-linux-2.dockerfile"
    local context_path="image/${service}/${version}/context"

    echo "Building Docker image: ${image_name}"
    sudo docker image build -t ${image_name} -f ${dockerfile_path} ${context_path}

    if [ $? -ne 0 ]; then
        echo "Failed to build Docker image: ${image_name}. Exiting."
        exit 1
    fi

    echo "Pushing Docker image: ${image_name} to Docker Hub"
    sudo docker push ${image_name}

    if [ $? -ne 0 ]; then
        echo "Failed to push Docker image: ${image_name}. Exiting."
        exit 1
    fi
}

# Check if Docker login is required
check_docker_login

# Services and versions
declare -A services=( 
    ["redis"]="4.0.9" 
    ["python"]="2.7" 
    ["nginx"]="1.14.0" 
)

# Loop through services and build and push each Docker image
for service in "${!services[@]}"; do
    build_and_push_image "$service" "${services[$service]}"
done

echo "All Docker images have been built and pushed to Docker Hub successfully!"
