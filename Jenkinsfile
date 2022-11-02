pipeline {
    
    agent any
    
    environment {

        registry = "414026235762.dkr.ecr.us-west-1.amazonaws.com/php-app"
        
    }
    
    stages 
    {
      stage('Git') {

            steps {

                checkout([$class: 'GitSCM', branches: [[name: '*/*']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/mfarhansayed/php-project.git']]])                   }

        }
        
           stage('SonarQube Analysis') {
               
             steps{
             withSonarQubeEnv(installationName: 'Sonar', credentialsId: 'sonarqube') {
                 sh "/var/lib/jenkins/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonar-scanner/bin/sonar-scanner"
                
            }
                
        }
    }
    stage("Quality Gate") {
            steps {
              timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
          }
       
        
    
    // Building Docker images
    stage('Building image') 
    {
      steps
      {
        script 
        {
          dockerImage = docker.build registry
        }
      }
    }
      // Uploading Docker images into AWS ECR
       stage('Pushing to ECR') {
       steps{  
         script {
                sh 'aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 414026235762.dkr.ecr.us-west-1.amazonaws.com'
                sh 'docker push 414026235762.dkr.ecr.us-west-1.amazonaws.com/php-app:latest'
         }
        }
      }
       // Stopping Docker containers for cleaner Docker run
         stage('stop previous containers') {
         steps {
            sh 'docker ps -f name=myphpContainer -q | xargs --no-run-if-empty docker container stop'
            sh 'docker container ls -a -fname=myphpContainer -q | xargs -r docker container rm'
         }
       }
        stage('Docker Run') {
        steps{
         script {
                sh 'docker run -d -p 8096:80 --rm --name myphpContainer 414026235762.dkr.ecr.us-west-1.amazonaws.com/php-app:latest'
            }
      }
    }
    stage('K8S Deploy') {
        steps{   
          sshagent(['k8']) {
            script{
                sh ('kubectl apply -f  k8.yaml')
            }
        }
       }  

    }
    }
    post {
        failure {
             emailext attachLog: true,
             body: '''
    Please Check the Code!! THE BUILD HAS FAILED''',   
    mimeType: 'text/html',
    subject: "failed",
    from: "farhansayed@zohomail.in",
    to: "farhansayed1116@gmail.com",
    recipientProviders: [[$class: 'CulpritsRecipientProvider']]
         }
    }  
}

    




