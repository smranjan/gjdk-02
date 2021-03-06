pipeline {
    agent any
    environment {
        DOCKER_TAG = getDockerTag()
    }
    stages {
        stage('Build Docker Image') {
            steps {
                sshagent(['kubemaster']) {
                sh "docker build . -t smranjan/gjdk_02:${DOCKER_TAG}"
                }
            }
        }
        stage('DockerHub Push') {
            steps {
                withCredentials([string(credentialsId: 'dockerHubsmranjanPwd', variable: 'dockerHubsmranjanPwd')]) {
                sh "docker login -u smranjan -p ${dockerHubsmranjanPwd}"
                sh "docker push smranjan/gjdk_02:${DOCKER_TAG}"
                } 
            }
        }
        stage('Deploy to k8s') {
            steps {
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG}"
                sshagent(['kubemaster']) {
                    sh "scp -Cr -o StrictHostKeyChecking=no k8s centos@10.10.1.34:/home/centos/"
                    script {
                        try {
                            sh "ssh centos@10.10.1.34 kubectl apply -f k8s/."
                        }catch(error) {
                            sh "ssh centos@10.10.1.34 kubectl create -f k8s/."
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
