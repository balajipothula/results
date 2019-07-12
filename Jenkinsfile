pipeline {

  environment {  
    pom        = readMavenPom()
    groupId    = pom.getGroupId()
    artifactId = pom.getArtifactId()
    version    = pom.getVersion()
    type       = pom.getPackaging()   
  }

  agent {
    label("master")
  }

  stages {
    
    stage("Environment Variables") {      
      steps {
        echo "${groupId}"
        echo "${artifactId}"
        echo "${version}"
        echo "${type}"
      }
    }

    stage("Git Clone") {
      steps{
        script{
          git(credentialsId: "git", url: "https://github.com/balajipothula/results.git", branch: "master")
        }
      }
    }

    stage("Maven Compile") {
      steps {
        script {
          withMaven(jdk: "jdk8u212", maven: "maven3.6.1") {
            sh "mvn clean install"
          }
        }
      }
    }
    
    stage("Nexus Artifact Upload") {
      steps {
        script {
          nexusArtifactUploader(artifacts: [[artifactId: "${artifactId}", classifier: "", file: "target/${artifactId}-${version}.${type}", type: "${type}"]], credentialsId: "nexus", groupId: "${groupId}", nexusUrl: "nexus.oss.balaji.network:8081/nexus", nexusVersion: "nexus2", protocol: "http", repository: "releases", version: "${version}.${BUILD_NUMBER}")
        }
      }
    }    

    stage("eMail Notification") {
      steps {
        script {
          emailext to: "balan.pothula@gmail.com", recipientProviders: [developers()], subject: '${DEFAULT_SUBJECT}', body: '${DEFAULT_CONTENT}'
        }
      }
    }

  }

}
