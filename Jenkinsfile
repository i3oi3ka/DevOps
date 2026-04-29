pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: jenkins-kaniko
spec:
  serviceAccountName: jenkins-sa
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:v1.16.0-debug
      imagePullPolicy: Always
      command:
        - sleep
      args:
        - 99d
    - name: git-tool
      image: alpine/git:latest
      imagePullPolicy: Always
      command:
        - sleep
      args: 
        - 99d
"""
    }
  }

  environment {
    ECR_REGISTRY = "472639102006.dkr.ecr.eu-west-2.amazonaws.com/ruday-lesson-db-ecr-repository"
    IMAGE_NAME   = "devops-ecr-repository"
    IMAGE_TAG    = "${env.BUILD_NUMBER}"
    REPO_URL     = "github.com/i3oi3ka/DevOps.git"
  }

  stages {
    stage('Build & Push Docker Image') {
      steps {
        container('kaniko') {
          sh '''
            /kaniko/executor \\
              --context `pwd` \\
              --dockerfile `pwd`/Dockerfile \\
              --destination=$ECR_REGISTRY/$IMAGE_NAME:$IMAGE_TAG \\
              --cache=true \\
              --insecure \\
              --skip-tls-verify
          '''
        }
      }
    }
  
  stage('GitOps: Update Helm Tag') {
            steps {
                container('git-tool') {
                    // Використовуємо id: github-token, який ти створив у values.yaml
                    withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                        sh """
                        git config --global user.email "jenkins@neovercity.com"
                        git config --global user.name "Jenkins Bot"

                        # Клонуємо репозиторій (той самий або інший, де лежать values.yaml чарту)
                        git clone https://${GIT_USER}:${GIT_PASS}@${REPO_URL} config-repo
                        cd config-repo
                        git checkout lesson-4

                        # Оновлюємо тег у values.yaml
                        cd charts/django-app/
                        sed -i "s/tag: .*/tag: ${IMAGE_TAG}/g" values.yaml

                        # Пушимо зміни
                        git add values.yaml
                        git commit -m "chore: update image tag to ${IMAGE_TAG} [skip ci]"
                        git push origin lesson-4
                        """
                    }
                }
            }
        }
  }
}

