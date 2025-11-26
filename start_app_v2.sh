#!/bin/bash

# Flask App Startup Script - Version 2
# This script completely detaches from Jenkins

WORKSPACE_DIR="/var/lib/jenkins/workspace/flask-cicd-app"
APP_PORT="5000"

# Change to workspace directory
cd $WORKSPACE_DIR

# Kill existing processes
pkill -f "gunicorn.*app:app" 2>/dev/null || true
sleep 2

# Close all file descriptors and detach completely
(
    # Activate virtual environment and start gunicorn
    source venv/bin/activate

    # Start gunicorn with complete detachment
    setsid gunicorn --bind 0.0.0.0:$APP_PORT --workers 2 app:app > gunicorn.log 2>&1 < /dev/null &

    # Save PID
    echo $! > gunicorn.pid

    disown
) &

sleep 2

echo "Flask app deployment initiated"
