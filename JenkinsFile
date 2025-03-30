pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'ayoubjarhni/mon-site-web'  
        DOCKER_TAG = 'latest'
    }

    stages {
       stage('Cloner le projet') {
    steps {
        withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
            sh 'git clone https://$GIT_USERNAME:$GIT_PASSWORD@github.com/AyoubeJarhni1/DeploiementAWS.git'
        }
    }
}

        
        stage('Test Docker') {
            steps {
                // Tester la version de Docker
                sh 'docker --version'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                // Construire l'image Docker avec le tag spécifié
                sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
            }
        }
        
        stage('Test Docker Image') {
            steps {
                script {
                    // Supprimer le conteneur précédent s'il existe
                    sh "docker rm -f test-container || true"
                    // Lancer l'image Docker en mode détaché pour tester l'accessibilité
                    sh "docker run -d -p 8081:80 --name test-container $DOCKER_IMAGE:$DOCKER_TAG"
                    // Vérifier la disponibilité avec curl
                    sh 'sleep 5'  // Attendre quelques secondes pour s'assurer que le conteneur est lancé
                    sh 'curl --fail http://localhost:8081 || exit 1'
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', 
                                                   usernameVariable: 'DOCKER_USERNAME', 
                                                   passwordVariable: 'DOCKER_PASSWORD')]) {
                    // Se connecter à Docker Hub avec les identifiants stockés dans Jenkins
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    // Pousser l'image Docker sur Docker Hub
                    sh 'docker push $DOCKER_IMAGE:$DOCKER_TAG'
                }
            }
        }
        
        // Optionnel : Nettoyage des conteneurs Docker après le test
        stage('Cleanup') {
            steps {
                sh 'docker stop test-container && docker rm test-container'
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline terminé avec succès!'
        }
        failure {
            echo 'Le pipeline a échoué!'
        }
    }
}
