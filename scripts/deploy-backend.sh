#!/bin/bash
# Script de déploiement du backend Spring Boot
# TP3 DEVOPS - M2 GL

echo "=========================================="
echo "Déploiement du Backend Spring Boot"
echo "=========================================="

JAR_FILE="/vagrant/backend/target/todoapp-0.0.1.jar"
SERVICE_FILE="/etc/systemd/system/springboot.service"

# Vérifier que le JAR existe
if [ ! -f "${JAR_FILE}" ]; then
    echo "JAR non trouvé. Construisez d'abord l'application:"
    echo "  cd /vagrant/backend && ./mvnw package -DskipTests"
    exit 1
fi

# Créer le service systemd
sudo tee ${SERVICE_FILE} > /dev/null <<EOF
[Unit]
Description=Spring Boot Application - TodoApp
After=network.target

[Service]
Type=simple
User=vagrant
WorkingDirectory=/vagrant/backend

Environment=JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
Environment=SPRING_DATASOURCE_URL=jdbc:mysql://192.168.56.31:3306/todoapp
Environment=SPRING_DATASOURCE_USERNAME=papabn
Environment=SPRING_DATASOURCE_PASSWORD=passer

ExecStart=/usr/bin/java -jar ${JAR_FILE}
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable springboot
sudo systemctl restart springboot

sleep 5
sudo systemctl status springboot --no-pager

echo "=========================================="
echo "Backend déployé sur http://192.168.56.30:8080"
echo "=========================================="
