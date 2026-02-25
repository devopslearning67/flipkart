pipeline {

    agent any

    environment {
        KEY = "/var/lib/jenkins/.ssh/Jenkins-Pem.pem"
        SERVER = "ec2-user@172.31.29.100"
        DEST = "/home/ec2-user/flipkart-docker"
        IMAGE = "flipkart-app"
        CONTAINER = "flipkart-c1"
    }

    stages {

        stage("Code Checkout") {
            steps {
                git branch: 'master',
                    url: 'https://github.com/devopslearning67/flipkart.git'
            }
        }

        stage("Deploy to Web Server") {
            steps {
                sh '''
                set -e
                echo "Starting Deployment..."

                # Create directory and fix ownership
                ssh -o StrictHostKeyChecking=no -i $KEY $SERVER "
                    sudo mkdir -p $DEST &&
                    sudo chown -R ec2-user:ec2-user $DEST
                "

                # Copy application files
                scp -o StrictHostKeyChecking=no -i $KEY $WORKSPACE/index.html $SERVER:$DEST/
                scp -o StrictHostKeyChecking=no -i $KEY $WORKSPACE/Dockerfile $SERVER:$DEST/

                # Build and Run Docker Container
                ssh -o StrictHostKeyChecking=no -i $KEY $SERVER "
                    cd $DEST &&
                    sudo docker rm -f $CONTAINER || true &&
                    sudo docker rmi $IMAGE:latest || true &&
                    sudo docker build -t $IMAGE:latest . &&
                    sudo docker run -d --name $CONTAINER -p 80:80 $IMAGE:latest
                "
                '''
            }
        }

        stage("Conclusion") {
            steps {
                echo "Pipeline executed successfully ✅"
            }
        }
    }
}
