@Library('slack') _

pipeline {
  agent any

  environment {
    deploymentName = "devsecops"
    containerName = "devsecops-container"
    serviceName = "devsecops-svc"
    imageName = "nthiep1998/numeric-app:${GIT_COMMIT}"
    applicationURL = "http://192.168.207.129"
    applicationURI = "/increment/99"
  }

  stages {
    stage('Build Artifact') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archive 'target/*.jar' //so that they can be downloaded later
        archive 'target/pit-reports/**'
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
      }
      post{
        always{
          pitmutation mutationStatsFile: 'target/pit-reports/**/mutations.xml'
        }
      }
    }

    stage('SonarQube - SAST') {
      steps {
        withSonarQubeEnv('sonarqube') {
          sh "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric-app -Dsonar.host.url=http://192.168.207.129:9000"
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
        parallel(
           "Dependency Scan": {
            sh "mvn dependency-check:check"
          },
           "Trivy Scan": {
            sh "bash trivy-scan1.sh"
          },
          "OPA Conftest": {
           sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security2.rego Dockerfile'
          }
        )
      }
    }
    stage('Docker Build and Push') {
      steps {
        withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
          sh 'printenv'
          sh 'sudo docker build -t nthiep1998/numeric-app:""$GIT_COMMIT"" .'
          sh 'docker push nthiep1998/numeric-app:""$GIT_COMMIT""'
        }
      }
    }
    stage('Vulnerability Scan - Kubernetes') {
      steps {
        parallel(
          "OPA Scan": {
            sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego k8s_deployment_service.yaml'
          },
          "Kubesec Scan": {
            sh "bash kubesec-scan.sh"
          },
          "Trivy Scan": {
            sh "bash trivy-k8s-scan.sh"
          }
        )
      }
    }
    stage('K8S Deployment - DEV') {
      steps {
        parallel(
          "Deployment": {
            withKubeConfig([credentialsId: 'kubeconfig']) {
              sh "bash k8s-deployment.sh"
            }
          },
          "Rollout Status": {
            withKubeConfig([credentialsId: 'kubeconfig']) {
             sh "bash k8s-deployment-rollout-status.sh"
            }
          }
        )
      }
    }
    stage('Integration Tests - DEV') {
      steps {
        script {
          try {
            withKubeConfig([credentialsId: 'kubeconfig']) {
              sh "bash integration-test.sh"
            }
          } catch (e) {
            withKubeConfig([credentialsId: 'kubeconfig']) {
              sh "kubectl -n default rollout undo deploy ${deploymentName}"
            }
            throw e
          }
        }
      }
    }

    stage('OWASP ZAP - DAST') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          sh 'bash zap.sh'
        }
      }
    }
    stage('Prompte to PROD?') {
      steps {
        timeout(time: 2, unit: 'DAYS') {
          input 'Do you want to Approve the Deployment to Production Environment/Namespace?'
        }
      }
    }

    stage('K8S CIS Benchmark') {
      steps {
        script {
          parallel(
            "Master": {
              sh "bash cis-master.sh"
            },
            "Etcd": {
              sh "bash cis-etcd.sh"
            },
            "Kubelet": {
              sh "bash cis-kubelet.sh"
            }
          )
        }
      }
    }

    stage('K8S Deployment - PROD') {
      steps {
        parallel(
          "Deployment": {
            withKubeConfig([credentialsId: 'kubeconfig']) {
              sh "bash node-service-prod.sh"              
              sh "sed -i 's#replace#${imageName}#g' k8s_PROD-deployment_service.yaml"
              sh "kubectl -n prod apply -f k8s_PROD-deployment_service.yaml"
            }
          },
          "Rollout Status": {
            withKubeConfig([credentialsId: 'kubeconfig']) {
              sh "bash k8s-PROD-deployment-rollout-status.sh"
            }
          }
        )
      }
    }

  }

  post {
    always {
      junit 'target/surefire-reports/*.xml'
      jacoco execPattern: 'target/jacoco.exec'
      dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
      publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'owasp-zap-report', reportFiles: 'zap_report.html', reportName: 'OWASP ZAP HTML Report', reportTitles: 'OWASP ZAP HTML Report', useWrapperFileDirectly: true])
      // Use sendNotifications.groovy from shared library and provide current build result as parameter    
      sendNotification currentBuild.result
    }
  }
}