pipeline {
  agent any
  stages {
    stage('Download sources') {
      steps {
        sh '''sudo rm -rf kickstart-docker
sudo rm -rf docker-images-build
sudo git clone https://github.com/sloopstash/kickstart-docker.git
sudo git clone https://github.com/Eliyaser/docker-images-build.git
sudo chown -R $USER docker-images-build
sudo chown -R $USER kickstart-docker'''
        sh '''sudo rm -rf kickstart-docker
sudo git clone https://github.com/sloopstash/kickstart-docker.git kickstart-docker'''
      }
    }

    stage('Build and Push') {
      steps {
        sh '''cd docker-images-build
sudo chmod +x script.sh
./script.sh'''
        echo 'All Docker images have been built and pushed successfully!'
      }
    }

  }
  environment {
    reponame = 'eliyaser'
  }
}