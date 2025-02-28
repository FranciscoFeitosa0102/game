# # Usar uma imagem oficial do Node.js
FROM node:16

# Diretório de trabalho
WORKDIR /usr/src/app

# Copiar os arquivos package.json e package-lock.json
COPY package*.json ./

# Instalar as dependências
RUN npm install

# Copiar todos os arquivos para dentro do contêiner
COPY . .

# Construir o projeto React
RUN npm run build

# Servir o conteúdo da pasta build
RUN npm install -g serve
CMD ["serve", "-s", "build", "-l", "80"]
