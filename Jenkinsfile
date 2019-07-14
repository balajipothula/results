pipeline {

  environment {
    pom        = readMavenPom()
    groupId    = pom.getGroupId()
    artifactId = pom.getArtifactId()
    version    = pom.getVersion()
    type       = pom.getPackaging()
    
    node       = 'master'
  }

  agent {
    label("${node}")
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
        sh "curl -O -u admin:admin123 'http://nexus.oss.balaji.network:8081/nexus/content/repositories/releases/com/bit/results/1.1.48/results-1.1.48.war'"
      }
    }
    
    stage("eMail Notification") {
      steps {
        emailext(to: "balan.pothula@gmail.com", recipientProviders: [developers()], subject: '${DEFAULT_SUBJECT}', body: '${DEFAULT_CONTENT}')
      }
    }

  }

}
