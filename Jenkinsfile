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
        echo "GroupId   : ${groupId}"
        echo "ArtifactId: ${artifactId}"
        echo "Version   : ${version}"
        echo "Packaging : ${type}"
        echo "Git Commit: ${GIT_COMMIT}"
        echo "Git URL   : ${GIT_URL}"
        echo "Node Name      : ${NODE_NAME}"
        echo "Job Name       : ${JOB_NAME}"
        echo "Build ID       : ${BUILD_ID}"
        echo "Build Number   : ${BUILD_NUMBER}"
        echo "Build Tag      : ${BUILD_TAG}"
        echo "Build URL      : ${BUILD_URL}"
        echo "Jenkins URL    : ${JENKINS_URL}"
        echo "Executor Number: ${EXECUTOR_NUMBER}"
        echo "Workspace      : ${WORKSPACE}"
      }
    }

    stage("Git Clone") {
      steps{
        echo "Cloning Source from GitHub..."
        git(credentialsId: "git", url: "https://github.com/balajipothula/results.git", branch: "master")
      }
    }

    stage("Maven Compile and SonarQube Code Quality Inspection") {
      steps {
        echo "Compiling Source using Maven..."
        withMaven(jdk: "jdk8u212", maven: "maven3.6.1") {
          sh "mvn clean install"
        //sh "mvn clean install sonar:sonar -Dsonar.host.url=http://13.233.216.75:9000 -Dsonar.login=6c4c6b142209f3eb997ce839bddc2ef0728b227d"
        //sh "cp ./target/results-1.1.war results.war"
        }
      }
    }
    
    stage("Nexus Artifact Upload") {
      steps {
        echo "Uploading Artifact into NexusOSS2..."
      //nexusArtifactUploader(artifacts: [[artifactId: "${artifactId}", classifier: "", file: "target/${artifactId}-${version}.${type}", type: "${type}"]], credentialsId: "nexus", groupId: "${groupId}", nexusUrl: "nexus.oss.balaji.network:8081/nexus", nexusVersion: "nexus2", protocol: "http", repository: "releases", version: "${version}.${BUILD_NUMBER}")
      }
    }

    stage("Pull Artifact") {
      steps {
        echo "Pulling Artifact from NexusOSS2..."
      //sh "curl -O -u admin:admin123 'http://nexus.oss.balaji.network:8081/nexus/content/repositories/releases/com/bit/${artifactId}/${version}.${BUILD_NUMBER}/${artifactId}-${version}.${BUILD_NUMBER}.${type}'"
      }
    }
    
    stage("Push Artifact") {
      steps {
        echo "Pushing Artifact into Tomcat Test Server..."
      //sh 'curl -v -T ./target/results-1.1.war -u tomcat:tomcat "http://13.233.109.154:8080/manager/text/deploy?path=/&update=true"'
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
      error("Build Failed")
      emailext(to: "balan.pothula@gmail.com", recipientProviders: [developers()], subject: '${DEFAULT_SUBJECT}', body: '${DEFAULT_CONTENT}')      
    }

  }

}
