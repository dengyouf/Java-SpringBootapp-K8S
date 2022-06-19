pipeline {
  agent {node { label "k8s-master-node-build"}}

  environment {
    gitUrl="https://gitee.com/dengyouf/java-spring-bootapp-k8s.git"
    hubUrl="reg.linux.io"
    dockerhub=credentials('harbor-admin-password')
    hubProject="springboot"
    buildTag="${sh(returnStdout: true, script: 'echo  -n $(git rev-parse --short HEAD)')}"
    appName="bootapp"
    new_IMAGE="$hubUrl/$hubProject/${appName}:$buildTag"
  }
  
  parameters {
    choice(
      name: 'branchName', 
      choices: ['master', 'developer', 'release'],
      description: 'Please choice your branch of the git repo')
  }
  stages {
    stage("Checkout") {
      steps {
          checkout([$class: 'GitSCM', branches: [[name: "${params.branchName}"]],
            extensions: [], 
            userRemoteConfigs: [[credentialsId: 'gitee-dengyouf-password', 
              url: "${env.gitUrl}"]]])
        }
      }
    stage("PrintEnv") {
      steps {
        sh 'printenv'
      }
    }
    stage("Build Code") {
      steps {
          sh """
          mvn clean install
          """
      }
    }
    stage("Build Image") {
      steps {
        sh '''
        docker build -t $hubUrl/$hubProject/${appName}:$buildTag .
        '''
      }
    }
    stage("Push Image") {
      steps {
        sh '''
        echo $dockerhub_PSW|docker login -u$dockerhub_USR  $hubUrl --password-stdin
        docker push $hubUrl/$hubProject/${appName}:$buildTag
        '''
      }
    }
    stage("Update YAML") {
        steps {
            sh """
            sed -i 's#_IMAGE_#${new_IMAGE}#g' Kubernetes/deployment.yaml
            """
        }
    }
    stage("Deploy to Cluster") {
        steps {
            sh 'kubectl apply -f Kubernetes'
        }
    }
  }
}
