pipeline {

    agent any

    stages {

        stage("Code Checkout") {
            steps {
                git branch: 'master',
                    url: 'https://github.com/devopslearning67/flipkart.git'
            }
        }

        stage("Release Latest Version into Webserver") {
            steps {
                sh '''
                set -e
                echo "Fetching the github repo content to jenkins server"

                KEY="/var/lib/jenkins/.ssh/Jenkins-Pem.pem"
                SERVER="ec2-user@172.31.29.100"
                DEST="/home/ec2-user/flipkart-docker"

                # Create directory on PROD server
                ssh -o StrictHostKeyChecking=no -i $KEY $SERVER "sudo mkdir -p $DEST"

                # Copy files
                scp -o StrictHostKeyChecking=no -i $KEY $WORKSPACE/index.html $SERVER:$DEST/
                scp -o StrictHostKeyChecking=no -i $KEY $WORKSPACE/Dockerfile $SERVER:$DEST/

                # Build and Deploy container
                ssh -o StrictHostKeyChecking=no -i $KEY $SERVER "
                    cd $DEST &&
                    sudo docker rm -f flipkart-c1 || true &&
                    sudo docker build -t flipkart-app:latest . &&
                    sudo docker run -d --name flipkart-c1 -p 80:80 flipkart-app:latest
                "
                '''
            }
        }

        stage("Conclusion message") {
            steps {
                echo "Pipeline executed successfully"
            }
        }
    }
}
