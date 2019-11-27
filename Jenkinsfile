pipeline {

  environment {
    displayName  = pom.getDisplayName()
    groupId      = pom.getGroupId()
    artifactId   = pom.getArtifactId()
    version      = pom.getVersion()
    type         = pom.getPackaging()
    relativePath = pom.getRelativePath()
  }

  agent {
    label("master")
  }
  
  stages {
    
    stage("Environment Variables") {
      steps {
      //echo "DisplayName : ${displayName}"
      //echo "GroupId     : ${groupId}"
      //echo "ArtifactId  : ${artifactId}"
      //echo "Version     : ${version}"
      //echo "Packaging   : ${type}"
      //echo "RelativePath: ${relativePath}"
        
        echo "DisplayName        : ${env.POM_DISPLAYNAME}"
        echo "GroupId            : ${env.POM_GROUPID}"
        echo "ArtifactId         : ${env.POM_ARTIFACTID}"
        echo "Version            : ${env.POM_VERSION}"
        echo "Packaging          : ${env.POM_PACKAGING}"
        echo "RelativePath       : ${env.POM_RELATIVEPATH}"
        
        echo "Git URL            : ${env.GIT_URL}"
        echo "Git Branch         : ${env.GIT_BRANCH}"
        echo "Git Commit         : ${env.GIT_COMMIT}"
        echo "Git Author Name    : ${env.GIT_AUTHOR_NAME}"
        echo "Git Author Email   : ${env.GIT_AUTHOR_EMAIL}"
        echo "Git Committer Name : ${env.GIT_COMMITTER_NAME}"
        echo "Git Committer eMail: ${env.GIT_COMMITTER_EMAIL}"
        
        echo "Node Name          : ${env.NODE_NAME}"
        echo "Job Name           : ${env.JOB_NAME}"
        echo "Build ID           : ${env.BUILD_ID}"
        echo "Build Number       : ${env.BUILD_NUMBER}"
        echo "Build Tag          : ${env.BUILD_TAG}"
        echo "Build URL          : ${env.BUILD_URL}"
        echo "Jenkins URL        : ${env.JENKINS_URL}"
        echo "Executor Number    : ${env.EXECUTOR_NUMBER}"
        echo "Workspace          : ${env.WORKSPACE}"
      }
    }

    stage("Git Clone...") {
      steps{
        echo "Cloning Source from GitHub..."
        git(credentialsId: "git", url: "https://github.com/balajipothula/results.git", branch: "master")
      }
    }

    stage("Maven Compile and SonarQube Code Quality Inspection") {
      steps {
        echo "Compiling Source using Maven..."
        withMaven(jdk: "jdk8u212", maven: "maven3.6.1") {
          sh "mvn clean validate compile test package verify install"
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
