pipeline {
    agent any
    environment {
        DOCKER_TAG = getDockerTag()
    }
    stages {
        stage('Build Docker Image') {
            steps {
                sshagent(['s01-devs']) {
                sh "docker build . -t smranjan/gjdk_01:${DOCKER_TAG}"
                }
            }
        }
        stage('DockerHub Push') {
            steps {
                withCredentials([string(credentialsId: 'dockerHubsmranjanPwd', variable: 'dockerHubsmranjanPwd')]) {
                sh "docker login -u smranjan -p ${dockerHubsmranjanPwd}"
                sh "docker push smranjan/gjdk_01:${DOCKER_TAG}"
                } 
            }
        }
        stage('Deploy to k8s') {
            steps {
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG}"
                sshagent(['s01-devs']) {
                    //sh "ssh devs@10.10.1.10 mkdir /home/devs/k8s"
                    sh "scp -Cr -o StrictHostKeyChecking=no k8s devs@10.10.1.10:/home/devs/"
                    script {
                        try {
                            sh "ssh devs@10.10.1.10 kubectl apply -f k8s/."
                        }catch(error) {
                            sh "ssh devs@10.10.1.10 kubectl create -f k8s/."
                        }
                    }
                }
            }
        }
    }
}

def getDockerTag() {
    //git url: 'https://github.com/smranjan/git-jenkins-docker.git', branch: 'master'
    def tag = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}

// #Testing
//  #Make changes to mylabfs/index.html
//  #Push code to Git
//  #Auto/Manual Build Using Jenkins
//  #Check 'kubectl get pods,svc -o wide'
//  #http://<mini_kube_ip_address>:31000/mylabfs