#!/bin/bash

echo "🚀 Iniciando a instalação do ambiente..."

# Atualizar pacotes do sistema
sudo apt update && sudo apt upgrade -y

# Instalar MongoDB
echo "📦 Instalando o MongoDB..."
sudo apt install -y mongodb

# Verificar se MongoDB está instalado
if ! command -v mongod &> /dev/null; then
    echo "❌ Erro ao instalar o MongoDB. Abortando."
    exit 1
fi

# Iniciar MongoDB e configurar para iniciar automaticamente
echo "🔄 Iniciando e habilitando MongoDB..."
sudo systemctl enable mongodb
sudo systemctl start mongodb

# Verificar status do MongoDB
if ! systemctl is-active --quiet mongodb; then
    echo "⚠️ O MongoDB não está rodando corretamente."
    exit 1
fi

# Instalar Node.js e npm via NodeSource para garantir versão recente
echo "📦 Instalando Node.js e npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Verificar versão instalada do Node.js
echo "✔️ Node.js versão: $(node -v)"
echo "✔️ npm versão: $(npm -v)"

# Clonar o repositório (caso necessário)
if [ ! -d "/var/www/gamifica" ]; then
    echo "📥 Clonando o repositório..."
    sudo git clone https://github.com/FranciscoFeitosa0102/game.git /var/www/gamifica
fi

# Instalar dependências do Node.js
echo "📦 Instalando dependências do projeto..."
cd /var/www/gamifica
npm install

# Instalar Nginx para configurar o Reverse Proxy
echo "🌍 Instalando e configurando o Nginx..."
sudo apt install -y nginx

# Criar configuração do Nginx
cat <<EOF | sudo tee /etc/nginx/sites-available/gamifica
server {
    listen 80;
    server_name gamifica.leadscdt.com.br;

    location / {
        proxy_pass http://localhost:5000;  # Alterado para a porta padrão do backend Node.js
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Ativar a configuração do Nginx
sudo ln -sf /etc/nginx/sites-available/gamifica /etc/nginx/sites-enabled/

# Testar configuração do Nginx
echo "✅ Testando a configuração do Nginx..."
sudo nginx -t

# Reiniciar Nginx para aplicar as mudanças
echo "🔄 Reiniciando o Nginx..."
sudo systemctl restart nginx

# Instalar PM2 para gerenciar o processo do Node.js
echo "⚙️ Instalando PM2..."
sudo npm install -g pm2

# Iniciar o servidor com PM2 e configurá-lo para iniciar automaticamente
echo "🚀 Iniciando o servidor com PM2..."
pm2 start server.js --name gamifica
pm2 save
pm2 startup systemd

# Informar ao usuário
echo "🎉 Instalação concluída! O projeto está rodando em: http://gamifica.leadscdt.com.br"
