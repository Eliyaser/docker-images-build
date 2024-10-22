## Jenkins Pipeline
####  Overview
This Jenkins pipeline automates the process of downloading a Git repository, building Docker images for specified services, and pushing these images to Docker Hub. The pipeline is designed to work in two main 

## stages:

Download Sources: This stage clones the necessary source files from the repository.
Build and Push Docker Images: This stage builds Docker images based on specified service versions and pushes them to Docker Hub.

#### Prerequisites
Jenkins installed and properly configured on your system.
Docker installed and available on the Jenkins agent.
A Docker Hub account for pushing the Docker images.
Jenkins credentials configured for Docker Hub login (referenced by dockerHub123 in the pipeline).

## Conclusion
This Jenkins pipeline streamlines the process of building and pushing Docker images. It is flexible enough to handle different services by simply modifying the services map, where you can add additional service names and versions. Ensure that the proper credentials for Docker Hub are set in Jenkins to securely handle image pushing.
