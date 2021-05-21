node{

    def mavenHome =  tool name: "maven-3.8.1", type: "maven"
    def mavenCMD = "${mavenHome}/bin/mvn"
    def buildNumber = BUILD_NUMBER
     
    stage('Git Checkout'){
        git branch: 'master', credentialsId: 'GIT_CREDENTIALS', url: 'https://github.com/banupraksh/ProductManager.git'
    }
    stage(" Build Package"){
      sh "${mavenCMD} clean package"
    }
     stage("Run Test Cases"){
      sh "${mavenCMD} test"
    }
    stage('Build Docker Image'){
        sh "docker rmi 9871234/productmanager:${currentBuild.previousBuild.getNumber()} || true"
        sh "docker build -t 9871234/productmanager:${buildNumber} ."
    }
    stage('Push Docker Image'){
        
        withCredentials([string(credentialsId: 'DOCKER_HUB_PASSWORD', variable: 'DOCKER_HUB_PASSWORD')]) {
        sh "docker login -u 9871234 -p ${DOCKER_HUB_PASSWORD}"
        }
        sh "docker push 9871234/productmanager:${buildNumber}"
     }
     stage('Deploy on Docker Container'){
         
         sshagent(['DOCKER_DEV_SERVER_SSH']) {
           sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.32.177 docker rm -f productmanager || true"
           sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.32.177 docker rmi 9871234/productmanager:${currentBuild.previousBuild.getNumber()} || true"
           sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.32.177 docker run -d -p 9090:8080 --name productmanager 9871234/productmanager:${buildNumber}"
            }
         
     }
    
}
