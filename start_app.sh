#!/bin/bash

# Flask App Startup Script
# This script runs independently of Jenkins

WORKSPACE_DIR="/var/lib/jenkins/workspace/flask-cicd-app"
APP_PORT="5000"

cd $WORKSPACE_DIR

# Kill existing processes
pkill -f "gunicorn.*app:app" || true
sleep 2

# Activate virtual environment
source venv/bin/activate

# Start gunicorn
gunicorn --bind 0.0.0.0:$APP_PORT --workers 2 app:app > gunicorn.log 2>&1 &

# Save PID
echo $! > gunicorn.pid

echo "Flask app started with PID: $(cat gunicorn.pid)"
