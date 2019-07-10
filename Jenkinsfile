pipeline {

  agent { label 'master' }

  stages {

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

  }

}
