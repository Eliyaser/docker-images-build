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
                            // Securely pass the password via stdin
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
