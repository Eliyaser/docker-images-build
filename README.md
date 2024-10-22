Jenkins Pipeline README
Overview
This Jenkins pipeline automates the process of downloading a Git repository, building Docker images for specified services, and pushing these images to Docker Hub. The pipeline is designed to work in two main stages:

Download Sources: This stage clones the necessary source files from the repository.
Build and Push Docker Images: This stage builds Docker images based on specified service versions and pushes them to Docker Hub.
Prerequisites
Jenkins installed and properly configured on your system.
Docker installed and available on the Jenkins agent.
A Docker Hub account for pushing the Docker images.
Jenkins credentials configured for Docker Hub login (referenced by dockerHub123 in the pipeline).
Pipeline Stages
1. Download Sources
This stage removes any existing local copy of the repository, clones a fresh copy of the kickstart-docker repository from GitHub, and adjusts file ownership to the current user.

bash
Copy code
sudo rm -rf kickstart-docker
sudo git clone https://github.com/sloopstash/kickstart-docker.git kickstart-docker
sudo chown -R $USER kickstart-docker
2. Build and Push Docker Images
In this stage, the pipeline loops over a list of services (in this example, only Redis with version 4.0.9) and:

Builds Docker images using the amazon-linux-2.dockerfile specific to the service and version.
Pushes the built Docker image to Docker Hub.
Docker Image Building
For each service, a Docker image is built using a specific Dockerfile and context path:

bash
Copy code
sudo docker image build -t eliyaser/redis:v4.0.9 -f image/redis/4.0.9/amazon-linux-2.dockerfile image/redis/4.0.9/context
Docker Hub Push
The Docker image is pushed to Docker Hub using credentials securely stored in Jenkins:

bash
Copy code
echo $dockerHub123Password | sudo docker login --username $dockerHub123User --password-stdin
sudo docker push eliyaser/redis:v4.0.9
3. Post Actions
After all images are built and pushed, the pipeline provides feedback:

On success, it logs the successful push of Docker images.
On failure, it logs an error message.
After all stages, it ensures Docker is logged out:
bash
Copy code
sudo docker logout
Credentials Setup
Open Jenkins.
Navigate to Manage Jenkins -> Manage Credentials.
Add a new Username with Password credential:
ID: dockerHub123
Username: <your-dockerhub-username>
Password: <your-dockerhub-password>
How to Use
Create a Jenkins job using this pipeline script.
Ensure the Jenkins agent has Docker installed and running.
Run the job to clone the repository, build Docker images, and push them to Docker Hub.
Example Pipeline Script
Below is the full pipeline script used in Jenkins:

groovy
Copy code
pipeline {
    agent any

    stages {
        stage('Download sources') {
          steps {
            sh '''
            sudo rm -rf kickstart-docker
            sudo git clone https://github.com/sloopstash/kickstart-docker.git kickstart-docker
            sudo chown -R $USER kickstart-docker
            '''
          }
        }

        stage('Build and Push Images') {
            steps {
                script {
                    def services = [
                        'redis': '4.0.9'
                    ]
                    services.each { service, version ->
                        def imageName = "eliyaser/${service}:v${version}"
                        def dockerfilePath = "image/${service}/${version}/amazon-linux-2.dockerfile"
                        def contextPath = "image/${service}/${version}/context"
                        dir('kickstart-docker') {
                            sh "pwd"
                            echo "Building Docker image: ${imageName}"
                            sh "sudo docker image build -t ${imageName} -f ${dockerfilePath} ${contextPath}"
                        }

                        echo "Pushing Docker image: ${imageName} to Docker Hub"
                        withCredentials([usernamePassword(credentialsId: 'dockerHub123', passwordVariable: 'dockerHub123Password', usernameVariable: 'dockerHub123User')]) {
                            sh '''
                            echo $dockerHub123Password | sudo docker login --username $dockerHub123User --password-stdin
                            '''
                            sh "sudo docker push ${imageName}"
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo "All Docker images have been built and pushed to Docker Hub successfully!"
        }
        failure {
            echo "Failed to build or push one or more Docker images."
        }
        always {
            sh 'sudo docker logout'
        }
    }
}
Conclusion
This Jenkins pipeline streamlines the process of building and pushing Docker images. It is flexible enough to handle different services by simply modifying the services map, where you can add additional service names and versions. Ensure that the proper credentials for Docker Hub are set in Jenkins to securely handle image pushing.
