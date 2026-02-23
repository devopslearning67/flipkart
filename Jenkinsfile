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

                # Create backup directory
                ssh -i /var/lib/jenkins/.ssh/Jenkins-Pem.pem ec2-user@172.31.29.100 "sudo mkdir -p /var/www/html/backup"
                
                # Backup existing index.html
                ssh -i /var/lib/jenkins/.ssh/Jenkins-Pem.pem ec2-user@172.31.29.100 \
                "if [ -f /var/www/html/index.html ]; then \
                sudo cp /var/www/html/index.html /var/www/html/backup/index.html.$(date +%Y%m%d-%H%M%S); \
                fi"
                
                # Copy new file
                scp -i /var/lib/jenkins/.ssh/Jenkins-Pem.pem $WORKSPACE/index.html \
                ec2-user@172.31.29.100:/tmp/index.html
                
                # Move file to web directory
                ssh -i /var/lib/jenkins/.ssh/Jenkins-Pem.pem ec2-user@172.31.29.100 \
                "sudo mv /tmp/index.html /var/www/html/index.html"
                
                echo "Deployment successful"
                '''
            }
        }
    }
}
