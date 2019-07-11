pipeline {

  agent { label 'master' }
  
  environment {
    groupId    = readMavenPom().getGroupId()
    artifactId = readMavenPom().getArtifactId()
    version    = readMavenPom().getVersion()
    type       = readMavenPom().getPackaging()
  }

  stages {
    
    stage('Environment Variables') {
      
      steps {
        echo "${groupId}"
        echo "${artifactId}"
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
         nexusArtifactUploader artifacts: [[artifactId: "${artifactId}", classifier: '', file: 'target/results-1.0.war', type: "${type}"]], credentialsId: 'nexus', groupId: "${groupId}", nexusUrl: 'nexus.oss.balaji.network:8081/nexus', nexusVersion: 'nexus2', protocol: 'http', repository: 'releases', version: "${version}.${BUILD_NUMBER}"
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
