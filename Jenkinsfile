pipeline {
    
    agent any
    
    environment {
        imageName = "app"
        registryCredentials = "newnexus"  
        registry = "52.53.250.93:8082"
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
    }
}

