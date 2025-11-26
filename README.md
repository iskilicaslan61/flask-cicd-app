# Flask CI/CD Application with Jenkins

Modern ve responsive bir Flask web uygulaması. Jenkins Pipeline ile otomatik deployment sağlar. Her push'ta otomatik olarak güncellenir.

## Özellikler

- Modern ve responsive tasarım
- Mavi tonlarında profesyonel tema
- Gerçek zamanlı ziyaretçi takibi
- RESTful API endpoints
- Jenkins CI/CD ile otomatik deployment
- Health check endpoint
- Systemd servis yönetimi

## Kurulum

### Yerel Geliştirme

\`\`\`bash
git clone https://github.com/iskilicaslan61/flask-cicd-app.git
cd flask-cicd-app
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
\`\`\`

### Jenkins ile Otomatik Deployment

1. Jenkins'te Pipeline job oluşturun
2. Git URL: https://github.com/iskilicaslan61/flask-cicd-app.git
3. Script Path: Jenkinsfile
4. GitHub webhook ekleyin

## Her Push Ettiğinizde Otomatik Güncellenir!

\`\`\`bash
git add .
git commit -m "Update"
git push origin main
# Jenkins otomatik olarak deploy eder!
\`\`\`

## API Endpoints

- GET / - Ana sayfa
- GET /about - Hakkında
- GET /health - Health check
- GET /api/visitors - Ziyaretçi listesi
- POST /api/visitors - Yeni ziyaretçi ekle
