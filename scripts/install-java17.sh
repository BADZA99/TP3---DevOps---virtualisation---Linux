#!/bin/bash
# Script d'installation de Java 17 sur Ubuntu
# TP3 DEVOPS - M2 GL

echo "=========================================="
echo "Installation de JDK 17"
echo "=========================================="

sudo apt-get update
sudo apt-get install -y openjdk-17-jdk maven

# Configuration de JAVA_HOME
echo 'JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"' | sudo tee -a /etc/environment
source /etc/environment

echo "=========================================="
echo "Java 17 installé!"
java -version
echo "=========================================="
