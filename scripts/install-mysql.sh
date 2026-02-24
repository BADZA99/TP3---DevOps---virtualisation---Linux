#!/bin/bash
# Script d'installation de MySQL sur Ubuntu
# TP3 DEVOPS - M2 GL

echo "=========================================="
echo "Installation de MySQL Server"
echo "=========================================="

sudo apt-get update
sudo apt-get install -y mysql-server

sudo systemctl enable mysql
sudo systemctl start mysql

# Autoriser connexions distantes
sudo sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Création base et utilisateur
sudo mysql <<EOF
CREATE DATABASE IF NOT EXISTS todoapp;

CREATE USER IF NOT EXISTS 'springuser'@'%' IDENTIFIED BY 'springpass';
GRANT ALL PRIVILEGES ON todoapp.* TO 'springuser'@'%';

USE todoapp;
CREATE TABLE IF NOT EXISTS todos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO todos (title, completed) VALUES ('Apprendre Vagrant', true);
INSERT INTO todos (title, completed) VALUES ('Configurer MySQL', true);
INSERT INTO todos (title, completed) VALUES ('Deployer Spring Boot', false);
INSERT INTO todos (title, completed) VALUES ('Deployer le Frontend', false);

FLUSH PRIVILEGES;
EOF

sudo systemctl restart mysql

echo "=========================================="
echo "MySQL installé!"
echo "Base: todoapp | User: springuser | Pass: springpass"
echo "=========================================="
