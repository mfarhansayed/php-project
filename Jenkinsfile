pipeline {
    
    agent any
    
    environment {
        imageName = "app"
        registryCredentials = "newnexus"  
        registry = "54.183.156.122:8082"
        dockerImage = ''
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
          dockerImage = docker.build imageName
        }
      }
    }
      // Uploading Docker images into Nexus Registry
    stage('Image upload to Nexus') {
     steps{  
         script {
             docker.withRegistry( 'http://'+registry, registryCredentials ) {
              version = VersionNumber(versionNumberString: '1.${BUILDS_ALL_TIME}')
             dockerImage.push(version)
           }
        }
      }
    }
    stage('Delete previous containers') {
         steps {
            sh 'docker ps -f name=app -q | xargs --no-run-if-empty docker container stop'
            sh 'docker container ls -a -fname=app -q | xargs -r docker container rm'
         }
       }
    
        stage('Docker Run') {
       steps{
         script {
            dockerImage.run("-p 80:80 --rm --name app")
               
            }
         }
      }
      stage('K8S Deploy') {
        steps{   
            script{

                sh ('kubectl apply -f  k8.yaml')
                
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
    




