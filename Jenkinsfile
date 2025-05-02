pipeline {
    agent any  

    environment {
        WORKSPACE_DIR = 'Workspace'  
        GITHUB_REPO_URL = 'https://github.com/H3Matteo/projet-Devops.git' 
        DOCKER_IMAGE_NAME = 'myapp-image'  
        CONTAINER_NAME = 'myapp'  
    }

    stages {
        stage('Clean Workspace') {
            steps {
                script {
                    echo "Nettoyage du dossier ${WORKSPACE_DIR}..."
                    sh """
                        if [ -d "${WORKSPACE_DIR}" ]; then
                            rm -rf ${WORKSPACE_DIR}  
                            echo "Dossier ${WORKSPACE_DIR} supprimé."
                        else
                            echo "Le dossier ${WORKSPACE_DIR} n'existe pas, rien à supprimer."
                        fi
                    """
                }
            }
        }

        stage('Clone GitHub Repository') {
            steps {
                script {
                    echo "Clonage du dépôt GitHub ${GITHUB_REPO_URL}..."
                    sh "git clone ${GITHUB_REPO_URL} ${WORKSPACE_DIR}"
                    echo "Dépôt cloné dans ${WORKSPACE_DIR}."
                }
            }
        }

        stage('Clean Docker Containers and Images') {
            steps {
                script {
                    echo "Nettoyage des conteneurs Docker existants..."
                    sh "docker container prune -f"
                    echo "Nettoyage des images Docker existantes..."
                    sh "docker image prune -af"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Construction de l'image Docker ${DOCKER_IMAGE_NAME}..."
                    sh """
                        if [ -f "${WORKSPACE_DIR}/Dockerfile" ]; then
                            echo "Dockerfile trouvé, construction de l'image Docker ${DOCKER_IMAGE_NAME}..."
                            docker build -t ${DOCKER_IMAGE_NAME} ${WORKSPACE_DIR}
                        else
                            echo "Erreur : Dockerfile introuvable dans le répertoire ${WORKSPACE_DIR}."
                            exit 1
                        fi
                    """
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    echo "Déploiement du conteneur Docker ${CONTAINER_NAME}..."
                    sh """
                        if [ \$(docker ps -a -q -f name=${CONTAINER_NAME}) ]; then
                            docker rm -f ${CONTAINER_NAME}  
                        fi
                    """
                    sh """
                        docker run -d --name ${CONTAINER_NAME} -p 8088:80 ${DOCKER_IMAGE_NAME}
                    """
                    def containerIp = sh(script: "docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${CONTAINER_NAME}", returnStdout: true).trim()
                    echo "L'adresse IP du conteneur ${CONTAINER_NAME} est : ${containerIp}"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline terminé."
        }
        success {
            echo "Le pipeline a réussi."
        }
        failure {
            echo "Le pipeline a échoué."
        }
    }
}
