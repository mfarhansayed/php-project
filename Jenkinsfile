pipeline {
    
    agent any
    
    environment {
        imageName = "app"
        registryCredentials = "newnexus"
        registry = "3.101.66.199:8082"
        dockerImage = ''
    }
    
    stages 
    {
        stage('Code checkout') 
        {
            steps {
                 git branch: 'main', url: 'https://github.com/mfarhansayed/php-project.git'
                }
        }
           stage('SonarQube Analysis') {
               
             steps{
             withSonarQubeEnv(installationName: 'Sonar', credentialsId: 'sonarqube') {
                 sh "/var/lib/jenkins/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonar-scanner/bin/sonar-scanner"
                
                
                
        
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
    stage('Uploading to Nexus') {
     steps{  
         script {
             docker.withRegistry( 'http://'+registry, registryCredentials ) {
             dockerImage.push('latest')
          }
        }
      }
      
    }
    stage('stop previous containers') {
         steps {
            sh 'docker ps -f name=myphpcontainer -q | xargs --no-run-if-empty docker container stop'
            sh 'docker container ls -a -fname=myphpcontainer -q | xargs -r docker container rm'
         }
       }
    
        stage('Docker Run') {
       steps{
         script {
            dockerImage.run("-p 83:80 --rm ")
               
            }
         }
      }  
    }
}

