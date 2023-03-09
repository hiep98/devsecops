pipeline {
  agent any

  stages {
    stage('Build Artifact') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archive 'target/*.jar' //so that they can be downloaded later
      }
    }
    stage('Unit Tests') {
      steps {
        sh "mvn test"
      }
    }
    stage('Mutation Tests - PIT') {
      steps {
        sh "mvn org.pitest:pitest-maven:mutationCoverage"
        dir('target/pit-reports') {
          pitmutation mutationStatsFile: '**/mutations.xml'
        }
        script {
            def mutationReports = findFiles(glob: 'target/pit-reports/**/mutations.xml')
            if (mutationReports.size() == 0) {
              echo "No mutation reports found!"
            } else {
              pitmutation mutationStatsFile: mutationReports[0].path
              archiveArtifacts artifacts: 'target/pit-reports/**', onlyIfSuccessful: true
              publishHTML(target: [
                allowMissing: false,
                alwaysLinkToLastBuild: false,
                keepAll: true,
                reportDir: 'target/pit-reports',
                reportFiles: 'index.html',
                reportName: 'Mutation Report'
              ])
            }
          }
      }
    }

    stage('SonarQube - SAST') {
      steps {
        withSonarQubeEnv('sonarqube') {
          sh "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric-app -Dsonar.host.url=http://192.168.126.132:9000"
        }
        timeout(time: 2, unit: 'MINUTES') {
          script {
            waitForQualityGate abortPipeline: true
          }
        }
      }
    }
    stage('Vulnerability Scan'){
      steps {
        sh "mvn dependency-check:check"
      }
    }
    stage('Docker Build and Push') {
      steps {
        withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
          sh 'printenv'
          sh 'docker build -t nthiep1998/numeric-app:""$GIT_COMMIT"" .'
          sh 'docker push nthiep1998/numeric-app:""$GIT_COMMIT""'
        }
      }
    }
    stage('Kubernetes Deployment - DEV') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          sh "sed -i 's#replace#nthiep1998/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
          sh "kubectl apply -f k8s_deployment_service.yaml"
        }
      }
    }
  }
  post{
    always{
        junit 'target/surefire-reports/*.xml'
        jacoco execPattern: 'target/jacoco.exec'
        pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
        // pitmutation mutationStatsFile: '**/pit-reports/**/mutations.xml'
        dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
    }
  }
}