# -*- mode: ruby -*-
# vi: set ft=ruby :

# TP3 DEVOPS - 3 VMs: server-back (Spring Boot) + server-dba (MySQL) + server-front (Nginx)
# Auteur:   PAPABNDEV M2 GL

Vagrant.configure("2") do |config|

  # ============================================
  # VM 1: server-back (Backend Spring Boot)
  # ============================================
  config.vm.define "server-back" do |back|
    back.vm.box = "ubuntu/jammy64"
    back.vm.hostname = "server-back"
    back.vm.box_check_update = false
    
    # Port Spring Boot (host 8084 pour éviter conflits)
    back.vm.network "forwarded_port", guest: 8080, host: 8084
    
    # Réseau privé
    back.vm.network "private_network", ip: "192.168.56.30"
    
    back.vm.provider "virtualbox" do |vb|
      vb.name = "server-back"
      vb.memory = "2048"
      vb.cpus = 2
    end
    
    back.vm.provision "shell", path: "scripts/install-java17.sh"
  end

  # ============================================
  # VM 2: server-dba (Base de données MySQL)
  # ============================================
  config.vm.define "server-dba" do |dba|
    dba.vm.box = "ubuntu/jammy64"
    dba.vm.hostname = "server-dba"
    dba.vm.box_check_update = false
    
    dba.vm.network "forwarded_port", guest: 3306, host: 3310
    dba.vm.network "private_network", ip: "192.168.56.31"
    
    dba.vm.provider "virtualbox" do |vb|
      vb.name = "server-dba"
      vb.memory = "1024"
      vb.cpus = 1
    end
    
    dba.vm.provision "shell", path: "scripts/install-mysql.sh"
  end

  # ============================================
  # VM 3: server-front (Frontend Nginx)
  # ============================================
  config.vm.define "server-front" do |front|
    front.vm.box = "ubuntu/jammy64"
    front.vm.hostname = "server-front"
    front.vm.box_check_update = false
    
    # Port Nginx (host 8085 pour éviter conflits)
    front.vm.network "forwarded_port", guest: 80, host: 8085
    
    front.vm.network "private_network", ip: "192.168.56.32"
    
    front.vm.provider "virtualbox" do |vb|
      vb.name = "server-front"
      vb.memory = "1024"
      vb.cpus = 1
    end
    
    front.vm.provision "shell", path: "scripts/install-nginx.sh"
  end

end
