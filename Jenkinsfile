pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = 'ayoubjarhni/mon-site-web'  
        DOCKER_TAG = 'latest'
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
    }

    stages {
        stage('Cloner le projet') {
            steps {
                script {
                    echo 'Clonage du projet depuis GitHub...'
                }
               withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
 {
                    sh 'git clone https://$GIT_USERNAME:$GIT_PASSWORD@github.com/AyoubeJarhni1/DeploiementAWS.git'
                }
            }
        }

        stage('Test Docker') {
            steps {
                script {
                    echo 'Vérification de la version de Docker...'
                }
                sh 'docker --version'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Construction de l\'image Docker...'
                }
                sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
            }
        }
        
        stage('Test Docker Image') {
            steps {
                script {
                    echo 'Suppression du conteneur précédent s\'il existe...'
                    sh "docker rm -f test-container || true"
                    echo 'Démarrage du conteneur en mode détaché...'
                    sh "docker run -d -p 8081:80 --name test-container $DOCKER_IMAGE:$DOCKER_TAG"
                    echo 'Attente de quelques secondes pour s\'assurer que le conteneur est lancé...'
                    // Ajout d'une vérification active
                    sh '''
                    for i in {1..5}; do
                        curl --silent --fail http://localhost:8081 && break
                        echo "Attente de la disponibilité du conteneur..."
                        sleep 3
                    done
                    '''
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo 'Connexion à Docker Hub...'
                }
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', 
                                                   usernameVariable: 'DOCKER_USERNAME', 
                                                   passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    echo 'Push de l\'image Docker sur Docker Hub...'
                    sh 'docker push $DOCKER_IMAGE:$DOCKER_TAG'
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                script {
                    echo 'Nettoyage des conteneurs Docker après le test...'
                }
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
