#!/bin/bash

echo "Iniciando instalação..."

# Atualizar o sistema
sudo apt update && sudo apt upgrade -y

# Instalar MongoDB
echo "Instalando o MongoDB..."
sudo apt install -y mongodb-server-core

# Verificar se o MongoDB foi instalado corretamente
if ! command -v mongod &> /dev/null
then
    echo "Erro ao instalar o MongoDB. Por favor, verifique."
    exit 1
fi

# Iniciar o MongoDB
echo "Iniciando MongoDB..."
sudo systemctl enable mongodb
sudo systemctl start mongodb

# Verificar o status do MongoDB
echo "Verificando o status do MongoDB..."
sudo systemctl status mongodb

# Instalar Node.js e npm
echo "Instalando Node.js e npm..."
sudo apt install -y nodejs npm

# Clonar o repositório do projeto
echo "Clonando o repositório..."
cd /var/www/
git clone https://github.com/FranciscoFeitosa0102/game.git gamifica_complete_project
cd gamifica_complete_project

# Instalar dependências do projeto (NPM)
echo "Instalando dependências do Node.js..."
npm install

# Instalar Nginx para configurar o Reverse Proxy
echo "Instalando o Nginx..."
sudo apt install -y nginx

# Configurar o Nginx para o projeto
echo "Configurando Nginx..."

cat <<EOF | sudo tee /etc/nginx/sites-available/gamifica
server {
    listen 80;
    server_name gamifica.leadscdt.com.br;

    location / {
        proxy_pass http://localhost:3000; # Porta onde o seu backend vai rodar
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Habilitar a configuração do Nginx
sudo ln -s /etc/nginx/sites-available/gamifica /etc/nginx/sites-enabled/

# Testar a configuração do Nginx
echo "Testando a configuração do Nginx..."
sudo nginx -t

# Reiniciar o Nginx
echo "Reiniciando o Nginx..."
sudo systemctl restart nginx

# Iniciar o projeto
echo "Iniciando o projeto..."
npm start

# Informar ao usuário
echo "Instalação concluída! O projeto está rodando em http://gamifica.leadscdt.com.br"

