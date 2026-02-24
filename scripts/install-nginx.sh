#!/bin/bash
# Script d'installation de Nginx sur Ubuntu
# TP3 DEVOPS - M2 GL

echo "=========================================="
echo "Installation de Nginx"
echo "=========================================="

sudo apt-get update
sudo apt-get install -y nginx

sudo systemctl enable nginx
sudo systemctl start nginx

# Configuration pour servir l'app frontend et faire proxy vers le backend
sudo tee /etc/nginx/sites-available/default > /dev/null <<'EOF'
server {
    listen 80 default_server;
    server_name _;
    
    # Dossier du frontend (React/Angular build)
    root /var/www/html;
    index index.html;
    
    # Routes frontend (SPA)
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Proxy vers le backend Spring Boot
    location /api/ {
        proxy_pass http://192.168.56.30:8080/api/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

sudo nginx -t
sudo systemctl reload nginx

echo "=========================================="
echo "Nginx installé!"
echo "Frontend: http://192.168.56.32"
echo "API proxy: http://192.168.56.32/api/"
echo "=========================================="
