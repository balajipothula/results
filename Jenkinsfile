pipeline {

  agent { label 'master' }
  
  environment {
    ARTIFACT_ID = readMavenPom().getArtifactId()
    VERSION     = readMavenPom().getVersion()
  }

  stages {
    
    stage('Environment Variables') {
      
      steps {
        echo "${ARTIFACT_ID}"
        echo "${VERSION}"
      }

    }

    stage('Git Clone') {

      steps{

        script{
          git credentialsId: 'git', url: 'https://github.com/balajipothula/results.git'
        }

      }

    }

    stage('Maven Compile') {

      steps {

        script {
          withMaven(jdk: 'jdk8u212', maven: 'maven3.6.1') {
            sh 'mvn clean install'
          }

        }

      }

    }
    
    stage('Nexus Artifact Upload') {

      steps {

        script {
         nexusArtifactUploader artifacts: [[artifactId: "${ARTIFACT_ID}", classifier: '', file: 'target/results-1.0.war', type: 'war']], credentialsId: 'nexus', groupId: 'com.bit', nexusUrl: 'nexus.oss.balaji.network:8081/nexus', nexusVersion: 'nexus2', protocol: 'http', repository: 'releases', version: "${VERSION}.${BUILD_NUMBER}"
        }

      }

    }    

    stage('eMail Notification') {

      steps {

        script {
          emailext to: 'balan.pothula@gmail.com', recipientProviders: [developers()], subject: '${DEFAULT_SUBJECT}', body: '${DEFAULT_CONTENT}'  
        }

      }

    }

  }

}
