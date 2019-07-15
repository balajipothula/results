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
        echo "GroupId: ${groupId}"
        echo "${artifactId}"
        echo "${version}"
        echo "${type}"
      }
    }

    stage("Git Clone") {
      steps{
        git(credentialsId: "git", url: "https://github.com/balajipothula/results.git", branch: "master")
      }
    }

    stage("Maven Compile") {
      steps {
        withMaven(jdk: "jdk8u212", maven: "maven3.6.1") {
          sh "mvn clean install"
          sh "cp ./target/results-1.1.war results.war"
        }
      }
    }
    
    stage("Nexus Artifact Upload") {
      steps {
        nexusArtifactUploader(artifacts: [[artifactId: "${artifactId}", classifier: "", file: "target/${artifactId}-${version}.${type}", type: "${type}"]], credentialsId: "nexus", groupId: "${groupId}", nexusUrl: "nexus.oss.balaji.network:8081/nexus", nexusVersion: "nexus2", protocol: "http", repository: "releases", version: "${version}.${BUILD_NUMBER}")
      }
    }

    stage("Pull Artifact") {
      steps {
        sh "curl -O -u admin:admin123 'http://nexus.oss.balaji.network:8081/nexus/content/repositories/releases/com/bit/${artifactId}/${version}.${BUILD_NUMBER}/${artifactId}-${version}.${BUILD_NUMBER}.${type}'"
      }
    }

  }

  post {
    
    always {
      echo "Build Finished"
    //deleteDir()
    }
    changed {
      echo "Build Changed"
    }
    unstable {
      echo "Build Unstable"
    }  
    success {
      echo "Build Successfull"
      emailext(to: "balan.pothula@gmail.com", recipientProviders: [developers()], subject: '${DEFAULT_SUBJECT}', body: '${DEFAULT_CONTENT}')
    }
    failure {
      echo "Build Failed"
      emailext(to: "balan.pothula@gmail.com", recipientProviders: [developers()], subject: '${DEFAULT_SUBJECT}', body: '${DEFAULT_CONTENT}')      
    }

  }

}
