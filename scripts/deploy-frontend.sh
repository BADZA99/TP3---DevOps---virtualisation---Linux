#!/bin/bash
# Script de déploiement du frontend
# TP3 DEVOPS - M2 GL

echo "=========================================="
echo "Déploiement du Frontend"
echo "=========================================="

FRONTEND_BUILD="/vagrant/frontend/dist"
NGINX_HTML="/var/www/html"

# Vérifier que le build existe
if [ ! -d "${FRONTEND_BUILD}" ]; then
    echo "Build frontend non trouvé."
    echo "Construisez d'abord l'application:"
    echo "  cd /vagrant/frontend && npm run build"
    echo ""
    echo "Déploiement de la page de test par défaut..."
    
    # Page de test simple
    sudo tee ${NGINX_HTML}/index.html > /dev/null <<'EOF'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TP3 DevOps - Frontend</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; justify-content: center; align-items: center; }
        .container { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); max-width: 600px; width: 90%; }
        h1 { color: #333; margin-bottom: 20px; }
        .status { padding: 15px; border-radius: 8px; margin: 10px 0; }
        .success { background: #d4edda; color: #155724; }
        .info { background: #cce5ff; color: #004085; }
        .todos { margin-top: 20px; }
        .todo-item { padding: 10px; border-bottom: 1px solid #eee; display: flex; align-items: center; }
        .todo-item input { margin-right: 10px; }
        .completed { text-decoration: line-through; color: #888; }
        button { background: #667eea; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; margin-top: 10px; }
        button:hover { background: #5a6fd6; }
        #error { color: red; margin-top: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h1> TP3 DevOps - Todo App</h1>
        
        <div class="status success">
             Frontend déployé sur Nginx (server-front)
        </div>
        
        <div class="status info">
             Backend: http://192.168.56.30:8080<br>
             Database: server-dba (MySQL)
        </div>
        
        <div class="todos">
            <h2> Liste des tâches</h2>
            <div id="todo-list">Chargement...</div>
            <div id="error"></div>
            <button onclick="loadTodos()"> Rafraîchir</button>
        </div>
    </div>
    
    <script>
        const API_URL = '/api/todos';
        
        async function loadTodos() {
            document.getElementById('error').textContent = '';
            try {
                const response = await fetch(API_URL);
                if (!response.ok) throw new Error('Erreur API: ' + response.status);
                const todos = await response.json();
                
                const html = todos.map(todo => `
                    <div class="todo-item">
                        <input type="checkbox" ${todo.completed ? 'checked' : ''} disabled>
                        <span class="${todo.completed ? 'completed' : ''}">${todo.title}</span>
                    </div>
                `).join('');
                
                document.getElementById('todo-list').innerHTML = html || '<p>Aucune tâche</p>';
            } catch (error) {
                document.getElementById('error').textContent = ' ' + error.message;
                document.getElementById('todo-list').innerHTML = '<p>Impossible de charger les données.</p>';
            }
        }
        
        loadTodos();
    </script>
</body>
</html>
EOF
    
    sudo systemctl reload nginx
    echo "Page de test déployée!"
    exit 0
fi

# Déployer le vrai build
sudo rm -rf ${NGINX_HTML}/*
sudo cp -r ${FRONTEND_BUILD}/* ${NGINX_HTML}/
sudo chown -R www-data:www-data ${NGINX_HTML}

sudo systemctl reload nginx

echo "=========================================="
echo "Frontend déployé sur http://192.168.56.32"
echo "=========================================="
