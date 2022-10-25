pipeline {
    
    agent any
    
    
    stages 
    {
      stage('Git chceckout') {

            steps {

                checkout([$class: 'GitSCM', branches: [[name: '*/*']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/mfarhansayed/php-project.git']]])                   
                }

        }
        
           
         }
    }  

    




