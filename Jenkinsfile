pipeline {
    agent any

    environment {
        APP_NAME = 'flask-cicd-app'
        APP_DIR = '/opt/flask-app'
        PYTHON_ENV = '/opt/flask-app/venv'
        GIT_REPO = 'https://github.com/iskilicaslan61/flask-cicd-app.git'
        APP_PORT = '5000'
    }

    stages {
        stage('Checkout') {
            steps {
                echo '📥 Checking out code from Git...'
                checkout scm
            }
        }

        stage('Setup Environment') {
            steps {
                echo '🔧 Setting up Python virtual environment...'
                sh '''
                    

                    # Create virtual environment if it doesn't exist
                    if [ ! -d "venv" ]; then
                        python3 -m venv venv
                    fi

                    # Activate and install dependencies
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                echo '🧪 Running application tests...'
                sh '''
                    
                    . venv/bin/activate

                    # Test if Flask app can be imported
                    python3 -c "from app import app; print('✅ Flask app imported successfully')"

                    # Check if health endpoint works
                    python3 -c "from app import app; client = app.test_client(); response = client.get('/health'); print('✅ Health check:', response.status_code)"
                '''
            }
        }

        stage('Build') {
            steps {
                echo '🏗️ Building application...'
                sh '''
                    
                    echo "Build timestamp: $(date)" > build_info.txt
                    echo "Git commit: $(git rev-parse --short HEAD)" >> build_info.txt
                    echo "Jenkins build: ${BUILD_NUMBER}" >> build_info.txt
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo '🚀 Deploying application...'
                sh '''
                    

                    # Create deployment directory if it doesn't exist
                    sudo mkdir -p ${APP_DIR}

                    # Copy application files
                    sudo cp -r * ${APP_DIR}/

                    # Set permissions
                    sudo chown -R jenkins:jenkins ${APP_DIR}

                    # Create or update systemd service
                    sudo bash -c 'cat > /etc/systemd/system/flask-app.service << EOF
[Unit]
Description=Flask CI/CD Application
After=network.target

[Service]
Type=simple
User=jenkins
WorkingDirectory=${APP_DIR}
Environment="PATH=${APP_DIR}/venv/bin"
ExecStart=${APP_DIR}/venv/bin/gunicorn --bind 0.0.0.0:${APP_PORT} --workers 2 app:app
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF'

                    # Reload systemd and restart service
                    sudo systemctl daemon-reload
                    sudo systemctl enable flask-app
                    sudo systemctl restart flask-app

                    # Wait for service to start
                    sleep 5

                    # Check service status
                    sudo systemctl status flask-app --no-pager
                '''
            }
        }

        stage('Health Check') {
            steps {
                echo '🏥 Running health check...'
                sh '''
                    # Wait a bit for the service to fully start
                    sleep 3

                    # Check if the application is responding
                    response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:${APP_PORT}/health || echo "000")

                    if [ "$response" = "200" ]; then
                        echo "✅ Health check passed! Application is running."
                    else
                        echo "❌ Health check failed! HTTP status: $response"
                        exit 1
                    fi
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
            echo "🎉 Application deployed and running at http://localhost:${APP_PORT}"
        }
        failure {
            echo '❌ Pipeline failed!'
            sh 'sudo journalctl -u flask-app -n 50 --no-pager || true'
        }
        always {
            echo '🧹 Cleaning up...'
            cleanWs(deleteDirs: true, patterns: [[pattern: 'venv/', type: 'INCLUDE']])
        }
    }
}
