#!/bin/bash

echo "Iniciando instalação..."

# Atualizar o sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependências básicas
sudo apt install -y curl git nginx

# Instalar MongoDB corretamente
echo "Instalando MongoDB..."
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -sc)/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update
sudo apt install -y mongodb-org

# Iniciar MongoDB
sudo systemctl enable mongod
sudo systemctl start mongod

# Verificar se MongoDB está rodando
if ! systemctl is-active --quiet mongod; then
    echo "Erro ao iniciar o MongoDB. Saindo..."
    exit 1
fi

# Instalar Node.js e npm via NVM
echo "Instalando Node.js..."
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install 18
nvm use 18

# Instalar PM2 para gerenciar processos Node.js
npm install -g pm2

# Clonar o repositório do projeto
echo "Clonando o repositório..."
sudo mkdir -p /var/www/gamifica_complete_project
sudo chown $USER:$USER /var/www/gamifica_complete_project
git clone https://github.com/FranciscoFeitosa0102/game.git /var/www/gamifica_complete_project
cd /var/www/gamifica_complete_project

# Instalar dependências do projeto
echo "Instalando dependências do Node.js..."
npm install

# Iniciar o projeto com PM2 para rodar na porta 3000
echo "Iniciando o projeto com PM2..."
pm2 start npm --name "gamifica" -- start
pm2 save
pm2 startup systemd

# Configurar o Nginx para proxy reverso na porta 3000
echo "Configurando Nginx..."

cat <<EOF | sudo tee /etc/nginx/sites-available/gamifica
server {
    listen 80;
    server_name gamifica.leadscdt.com.br;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Habilitar a configuração no Nginx
sudo ln -sf /etc/nginx/sites-available/gamifica /etc/nginx/sites-enabled/

# Testar configuração e reiniciar Nginx
sudo nginx -t && sudo systemctl reload nginx

# Informar ao usuário
echo "Instalação concluída! Acesse http://gamifica.leadscdt.com.br"
