#!/bin/bash

# Flask CI/CD Deployment Script
# This script can be used for manual deployment or testing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="flask-cicd-app"
APP_DIR="/opt/flask-app"
APP_PORT="5000"
SERVICE_NAME="flask-app"

echo -e "${BLUE}🚀 Starting Flask Application Deployment${NC}"
echo "================================================"

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ Please run this script with sudo${NC}"
    exit 1
fi

# Step 1: Create application directory
echo -e "${YELLOW}📁 Creating application directory...${NC}"
mkdir -p $APP_DIR
cd $APP_DIR

# Step 2: Copy application files
echo -e "${YELLOW}📋 Copying application files...${NC}"
if [ -d "$OLDPWD" ]; then
    cp -r $OLDPWD/* $APP_DIR/
else
    echo -e "${RED}❌ Source directory not found${NC}"
    exit 1
fi

# Step 3: Setup Python virtual environment
echo -e "${YELLOW}🐍 Setting up Python virtual environment...${NC}"
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

# Activate virtual environment and install dependencies
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Step 4: Create systemd service
echo -e "${YELLOW}⚙️  Creating systemd service...${NC}"
cat > /etc/systemd/system/$SERVICE_NAME.service << EOF
[Unit]
Description=Flask CI/CD Application
After=network.target

[Service]
Type=simple
User=$(logname || echo jenkins)
WorkingDirectory=$APP_DIR
Environment="PATH=$APP_DIR/venv/bin"
ExecStart=$APP_DIR/venv/bin/gunicorn --bind 0.0.0.0:$APP_PORT --workers 2 app:app
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Step 5: Set permissions
echo -e "${YELLOW}🔐 Setting permissions...${NC}"
chown -R $(logname || echo jenkins):$(logname || echo jenkins) $APP_DIR

# Step 6: Enable and start service
echo -e "${YELLOW}🔄 Reloading systemd and starting service...${NC}"
systemctl daemon-reload
systemctl enable $SERVICE_NAME
systemctl restart $SERVICE_NAME

# Wait for service to start
sleep 3

# Step 7: Check service status
echo -e "${YELLOW}🔍 Checking service status...${NC}"
if systemctl is-active --quiet $SERVICE_NAME; then
    echo -e "${GREEN}✅ Service is running!${NC}"
    systemctl status $SERVICE_NAME --no-pager
else
    echo -e "${RED}❌ Service failed to start!${NC}"
    journalctl -u $SERVICE_NAME -n 50 --no-pager
    exit 1
fi

# Step 8: Health check
echo -e "${YELLOW}🏥 Running health check...${NC}"
sleep 2
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$APP_PORT/health || echo "000")

if [ "$response" = "200" ]; then
    echo -e "${GREEN}✅ Health check passed!${NC}"
    echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
    echo -e "${BLUE}📍 Application is running at: http://localhost:$APP_PORT${NC}"
else
    echo -e "${RED}❌ Health check failed! HTTP status: $response${NC}"
    exit 1
fi

echo "================================================"
echo -e "${GREEN}✨ Deployment finished!${NC}"
