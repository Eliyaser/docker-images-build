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
        sh '''def services = [\'nginx\': \'1.14.0\']

services.each { service, version ->
                        def imageName = "${reponame}/${service}:v${version}"
                        def dockerfilePath = "image/${service}/${version}/amazon-linux-2.dockerfile"
                        def contextPath = "image/${service}/${version}/context"
                        
                       
                        echo "Building Docker image: ${imageName}"
                        sudo docker build -t ${imageName} -f ${dockerfilePath} ${contextPath}
                        if [ $? -ne 0 ]; then
                            echo "Failed to build Docker image: ${imageName}. Exiting."
                            exit 1
                        fi

                        echo "Pushing Docker image: ${imageName} to Docker Hub"
                        sudo docker push ${imageName}
                        if [ $? -ne 0 ]; then
                            echo "Failed to push Docker image: ${imageName}. Exiting."
                            exit 1
                        fi
                       
                    }
'''
        echo 'All Docker images have been built and pushed successfully!'
      }
    }

  }
  environment {
    reponame = 'eliyaser'
  }
}