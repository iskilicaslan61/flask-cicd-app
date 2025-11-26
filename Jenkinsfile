pipeline {
    agent any

    environment {
        APP_NAME = 'flask-cicd-app'
        APP_PORT = '5000'
        GIT_REPO = 'https://github.com/iskilicaslan61/flask-cicd-app.git'
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
                echo '🚀 Deploying application with systemd...'
                sh '''
                    # Copy systemd service file
                    sudo cp flask-app.service /etc/systemd/system/

                    # Reload systemd to recognize new service
                    sudo systemctl daemon-reload

                    # Enable service to start on boot
                    sudo systemctl enable flask-app

                    # Restart the service (will start if not running, restart if running)
                    sudo systemctl restart flask-app

                    # Wait for service to start
                    sleep 3

                    # Check service status
                    sudo systemctl status flask-app --no-pager || true

                    # Verify process is running
                    if sudo systemctl is-active --quiet flask-app; then
                        echo "✅ Application deployed successfully via systemd!"
                        ps aux | grep "gunicorn.*app:app" | grep -v grep | head -3
                    else
                        echo "❌ Failed to start application"
                        sudo journalctl -u flask-app -n 20 --no-pager
                        exit 1
                    fi
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
                        echo "📊 Application info:"
                        curl -s http://localhost:${APP_PORT}/health | python3 -m json.tool || true
                    else
                        echo "❌ Health check failed! HTTP status: $response"
                        sudo journalctl -u flask-app -n 20 --no-pager
                        exit 1
                    fi
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
            echo "🎉 Application deployed and running at http://100.29.190.54:${APP_PORT}"
            echo "📋 Service management commands:"
            echo "   sudo systemctl status flask-app"
            echo "   sudo systemctl restart flask-app"
            echo "   sudo journalctl -u flask-app -f"
        }
        failure {
            echo '❌ Pipeline failed!'
            sh '''
                echo "Recent application logs:"
                ps aux | grep gunicorn || true
                sudo systemctl status flask-app --no-pager || true
                sudo journalctl -u flask-app -n 30 --no-pager || true
            '''
        }
        always {
            echo '🧹 Build completed!'
        }
    }
}
