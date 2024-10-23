# Jenkins Pipeline for Building and Pushing Docker Images
####  Overview:
This pipeline automates the process of building Docker images for multiple services and pushing them to Docker Hub. It pulls service versions from a shell script (script.sh) and handles Docker Hub authentication through Jenkins credentials.

## Steps:

#### 1. Create Docker Hub Credentials in Jenkins:
Go to Jenkins Dashboard > Manage Jenkins > Manage Credentials.
Add usernamePassword credentials:
ID: dockerHub123
Username: <your-docker-hub-username>
Password: <your-docker-hub-password>.

#### 2. Modify 
Update the services array in script.sh to include all required services and their versions. Example:

```
# Services and versions
declare -A services=(
    ["redis"]="4.0.9"
    ["nginx"]="1.18.0"   # Add more services as needed
)
```
The script will loop through these services and build Docker images accordingly.

#### 3.Jenkinsfile Modifications:
Update the Jenkinsfile to match the services defined in the shell script. Example:
```
def services = [
    'redis': '4.0.9',
    'nginx': '1.18.0'  // Match with script.sh
]

```

This Jenkinsfile will loop through the services and push each Docker image to Docker Hub.

#### 4.Pipeline Authentication Setup:
Use the Docker Hub credentials securely in the Jenkins pipeline by adding the following snippet to the Jenkinsfile:

```
withCredentials([usernamePassword(credentialsId: 'dockerHub123', passwordVariable: 'dockerHub123Password', usernameVariable: 'dockerHub123User')]) {
    sh '''
    echo $dockerHub123Password | sudo docker login --username $dockerHub123User --password-stdin
    '''
    sh "sudo docker push ${imageName}"
}

```
This ensures Docker Hub credentials are handled securely and images are pushed correctly.

*************************************************************************************************
By following these steps, you'll set up an efficient pipeline to manage Docker image builds and deployments to Docker Hub.


