pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "ayoubjarhni/mon-site-web"
        DOCKER_REGISTRY = "docker.io" // Docker Hub par exemple
        DOCKERHUB_USERNAME = credentials('docker-hub-credentials')  // Utilisation de l'ID des credentials pour le nom d'utilisateur
        DOCKERHUB_PASSWORD = credentials('docker-hub-credentials')  // Utilisation de l'ID des credentials pour le mot de passe
    }
    stages {
        stage('Checkout') {
            steps {
                echo 'Clonage du projet depuis GitHub...'
                git url: 'https://github.com/AyoubeJarhni1/DeploiementAWS.git', branch: 'main'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Construction de l\'image Docker...'
                script {
                    docker.build(DOCKER_IMAGE, '.')
                }
            }
        }
        
        stage('Test Docker Image') {
            steps {
                echo 'Vérification du bon fonctionnement de l\'image Docker...'
                script {
                    // Exécuter l'image Docker localement et tester l'accessibilité via curl
                    docker.image(DOCKER_IMAGE).inside {
                        bat 'curl -f http://localhost:80 || exit 1'
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo 'Poussée de l\'image Docker sur Docker Hub...'
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", "${DOCKERHUB_USERNAME}:${DOCKERHUB_PASSWORD}") {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }

        stage('Deploy in Review') {
            steps {
                echo 'Déploiement de l\'image Docker dans un environnement de revue...'
                script {
                    // Simuler un déploiement sur une machine locale ou virtuelle (pas AWS ici)
                    bat 'docker run -d -p 8080:80 $DOCKER_IMAGE'
                    echo 'Déploiement effectué sur le port 8080.'
                }
            }
        }
        
        stage('Deploy in Staging') {
            steps {
                echo 'Déploiement dans l\'environnement de staging...'
                script {
                    // Répéter le déploiement sur un autre environnement simulé
                    bat 'docker run -d -p 8081:80 $DOCKER_IMAGE'
                    echo 'Déploiement effectué sur le port 8081.'
                }
            }
        }

        stage('Deploy in Production') {
            steps {
                echo 'Déploiement en production...'
                script {
                    // Déploiement final en production simulée sur le port 8082
                    bat 'docker run -d -p 8082:80 $DOCKER_IMAGE'
                    echo 'Déploiement effectué sur le port 8082.'
                }
            }
        }
    }
    
    post {
        always {
            echo 'Nettoyage des ressources...'
            // Nettoyage des containers Docker
            bat 'docker system prune -f'
        }
        success {
            echo 'Pipeline exécuté avec succès.'
        }
        failure {
            echo 'Le pipeline a échoué.'
        }
    }
}
