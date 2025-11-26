# Flask CI/CD Application with Jenkins

Modern ve responsive bir Flask web uygulaması. Jenkins Pipeline ile otomatik deployment sağlar.

## Özellikler

- Modern ve responsive tasarım
- Mavi tonlarında profesyonel tema
- Gerçek zamanlı ziyaretçi takibi
- RESTful API endpoints
- Jenkins CI/CD ile otomatik deployment
- Health check endpoint
- Systemd servis yönetimi

## Teknolojiler

- **Backend:** Python Flask 3.0
- **Frontend:** HTML5, CSS3, Vanilla JavaScript
- **CI/CD:** Jenkins Pipeline
- **Server:** Gunicorn WSGI Server
- **Service Management:** Systemd

## Proje Yapısı

```
Python-flask-app-jenkins/
├── app.py                  # Ana Flask uygulaması
├── requirements.txt        # Python bağımlılıkları
├── Jenkinsfile            # Jenkins pipeline tanımı
├── deploy.sh              # Manuel deployment scripti
├── .gitignore             # Git ignore kuralları
├── templates/             # HTML şablonları
│   ├── base.html         # Ana şablon
│   ├── index.html        # Ana sayfa
│   └── about.html        # Hakkında sayfası
└── static/               # Statik dosyalar
    ├── css/
    │   └── style.css     # Ana stil dosyası
    └── js/
        └── main.js       # JavaScript dosyası
```

## Kurulum

### 1. Gereksinimler

- Python 3.8 veya üzeri
- Jenkins (CI/CD için)
- Git
- Sudo erişimi (deployment için)

### 2. Yerel Geliştirme

```bash
# Repoyu klonlayın
git clone https://github.com/ondiacademy/ondia-aws-devops-12.git
cd ondia-aws-devops-12/Jenkin-uygulama/Python-flask-app-jenkins

# Virtual environment oluşturun
python3 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Bağımlılıkları yükleyin
pip install -r requirements.txt

# Uygulamayı çalıştırın
python app.py
```

Uygulama `http://localhost:5000` adresinde çalışacaktır.

### 3. Production Deployment

#### Manuel Deployment

```bash
sudo bash deploy.sh
```

#### Jenkins ile Otomatik Deployment

1. **Jenkins Pipeline Job Oluşturun:**
   - Jenkins Dashboard > New Item
   - Pipeline türünde bir job oluşturun
   - Pipeline bölümünde "Pipeline script from SCM" seçin
   - Git URL'inizi girin
   - Script Path: `Jenkin-uygulama/Python-flask-app-jenkins/Jenkinsfile`

2. **GitHub Webhook Yapılandırın:**
   - GitHub repo > Settings > Webhooks
   - Add webhook
   - Payload URL: `http://jenkins-sunucu:8080/github-webhook/`
   - Content type: `application/json`
   - Events: `Just the push event`

3. **Jenkins'te GitHub Integration:**
   - Job Configuration > Build Triggers
   - "GitHub hook trigger for GITScm polling" seçeneğini işaretleyin

## API Endpoints

### GET /
Ana sayfa

### GET /about
Hakkında sayfası

### GET /health
Sağlık kontrolü endpoint'i
```json
{
  "status": "healthy",
  "timestamp": "2024-11-26T10:30:00",
  "version": "1.0.0"
}
```

### GET /api/visitors
Tüm ziyaretçileri listeler
```json
{
  "visitors": [...],
  "count": 5
}
```

### POST /api/visitors
Yeni ziyaretçi ekler
```json
{
  "name": "Ali Yılmaz",
  "message": "Harika bir uygulama!"
}
```

## Jenkins Pipeline Aşamaları

Pipeline şu aşamalardan oluşur:

1. **Checkout:** Kodu Git'ten çeker
2. **Setup Environment:** Python virtual environment kurar
3. **Run Tests:** Uygulamayı test eder
4. **Build:** Build bilgilerini oluşturur
5. **Deploy:** Uygulamayı production'a deploy eder
6. **Health Check:** Deployment'ın başarılı olduğunu kontrol eder

## Systemd Servis Yönetimi

```bash
# Servisi başlat
sudo systemctl start flask-app

# Servisi durdur
sudo systemctl stop flask-app

# Servisi yeniden başlat
sudo systemctl restart flask-app

# Servis durumunu kontrol et
sudo systemctl status flask-app

# Logları görüntüle
sudo journalctl -u flask-app -f
```

## Geliştirme

### Kod Değişikliklerini Deploy Etme

1. Değişikliklerinizi yapın
2. Git'e commit edin:
```bash
git add .
git commit -m "Yeni özellik eklendi"
git push origin main
```

3. Jenkins otomatik olarak:
   - Değişiklikleri algılar (GitHub webhook)
   - Pipeline'ı çalıştırır
   - Testleri yapar
   - Uygulamayı deploy eder

## Güvenlik

- `.gitignore` ile hassas dosyalar korunur
- Environment variables ile yapılandırma
- Systemd ile güvenli servis yönetimi
- Health check endpoint ile monitoring

## Troubleshooting

### Uygulama başlamıyor

```bash
# Logları kontrol edin
sudo journalctl -u flask-app -n 50

# Port kullanımda mı kontrol edin
sudo netstat -tulpn | grep 5000

# Servisi yeniden başlatın
sudo systemctl restart flask-app
```

### Jenkins pipeline başarısız

```bash
# Jenkins kullanıcısının sudo yetkisi var mı kontrol edin
sudo visudo
# Ekleyin: jenkins ALL=(ALL) NOPASSWD: ALL

# Virtual environment kurulabilir mi test edin
python3 -m venv test-venv
```

## Katkıda Bulunma

1. Bu repository'i fork edin
2. Feature branch oluşturun (`git checkout -b feature/yenilik`)
3. Değişikliklerinizi commit edin (`git commit -m 'Yeni özellik eklendi'`)
4. Branch'inizi push edin (`git push origin feature/yenilik`)
5. Pull Request oluşturun

## Lisans

Bu proje ONDIA Academy eğitim amaçlı oluşturulmuştur.

## İletişim

ONDIA Academy - DevOps Eğitim Programı

## Ekran Görüntüleri

Uygulama çalıştırıldığında:
- Modern mavi temalı ana sayfa
- Ziyaretçi sayacı
- İnteraktif ziyaretçi defteri
- Responsive tasarım
- Smooth animasyonlar

## Version History

- **v1.0.0** (2024-11-26)
  - İlk release
  - Flask 3.0 ile modern yapı
  - Jenkins CI/CD entegrasyonu
  - Mavi tema tasarımı
  - Systemd servis yönetimi
