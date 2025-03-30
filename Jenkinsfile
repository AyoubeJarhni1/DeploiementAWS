pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = "votre_nom_utilisateur/image_web" // Nom de l'image Docker que vous souhaitez construire
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials') // Nom des credentials Docker Hub dans Jenkins
    }

    stages {
        stage('Build') {
            steps {
                script {
                    // Cloner le projet et construire l'image Docker
                    echo "Clonage du projet..."
                    checkout scm
                    echo "Construction de l'image Docker..."
                    sh 'docker build -t $DOCKER_IMAGE_NAME .'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Vérifier l'accès de l'image Docker
                    echo "Test de l'image Docker..."
                    sh 'docker run -d -p 8080:80 $DOCKER_IMAGE_NAME'
                    sleep(10)  // Attente pour le démarrage du conteneur
                    // Tester l'accessibilité de l'application avec curl
                    sh 'curl -f http://localhost:8080 || exit 1'
                    echo "L'image Docker est accessible."
                }
            }
        }

        stage('Release') {
            steps {
                script {
                    // Pousser l'image Docker sur Docker Hub
                    echo "Poussée de l'image Docker sur Docker Hub..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                        sh 'docker push $DOCKER_IMAGE_NAME'
                    }
                }
            }
        }
    }

    post {
        always {
            // Nettoyage des ressources après l'exécution
            echo "Nettoyage des conteneurs et images Docker..."
            sh 'docker system prune -af'
        }
        success {
            echo "Pipeline CI/CD réussi."
        }
        failure {
            echo "Échec du pipeline CI/CD."
        }
    }
}
