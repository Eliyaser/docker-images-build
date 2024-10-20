pipeline {
  agent any
  stages {
    stage('Download sources') {
      steps {
        sh '''sudo rm -rf kickstart-docker
sudo git clone https://github.com/sloopstash/kickstart-docker.git kickstart-docker

 '''
        sh '''sudo rm -rf kickstart-docker
sudo git clone https://github.com/sloopstash/kickstart-docker.git kickstart-docker'''
      }
    }

    stage('Build and Push') {
      steps {
        sh '''# Function to build and push a Docker image
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


# Services and versions
declare -A services=( 
    ["redis"]="4.0.9" 
)

# Loop through services and build and push each Docker image
for service in "${!services[@]}"; do
    build_and_push_image "$service" "${services[$service]}"
done

echo "All Docker images have been built and pushed to Docker Hub successfully!"
'''
        echo 'All Docker images have been built and pushed successfully!'
      }
    }

  }
  environment {
    reponame = 'eliyaser'
  }
}