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
                echo '🚀 Deploying application...'
                sh '''
                    # Kill any existing processes
                    pkill -f "gunicorn.*app:app" || true
                    sleep 2

                    # Activate virtual environment
                    . venv/bin/activate

                    # Start gunicorn with complete detachment from Jenkins
                    # Using subshell, disown, and redirecting all file descriptors
                    (
                        # Close stdin, stdout, stderr
                        exec 0</dev/null
                        exec 1>gunicorn.log
                        exec 2>&1

                        # Start gunicorn in new session
                        setsid gunicorn --bind 0.0.0.0:${APP_PORT} --workers 2 app:app &

                        # Save PID
                        echo $! > gunicorn.pid

                        # Disown to remove from job table
                        disown
                    ) &

                    # Wait for application to start
                    echo "⏳ Waiting for application to start..."
                    sleep 5

                    # Verify process is running
                    if pgrep -f "gunicorn.*app:app" > /dev/null; then
                        echo "✅ Application deployed successfully!"
                        ps aux | grep "gunicorn.*app:app" | grep -v grep | head -3
                    else
                        echo "❌ Failed to start application"
                        cat gunicorn.log 2>/dev/null || echo "No log file yet"
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
            echo "🎉 Application deployed and running at http://100.29.190.54:${APP_PORT}"
        }
        failure {
            echo '❌ Pipeline failed!'
            sh '''
                echo "Recent application logs:"
                ps aux | grep gunicorn || true
                lsof -i:${APP_PORT} || true
            '''
        }
        always {
            echo '🧹 Build completed!'
        }
    }
}
