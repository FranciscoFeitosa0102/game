# Usar uma imagem oficial do Node.js
FROM node:16

# Diretório de trabalho
WORKDIR /usr/src/app

# Copiar os arquivos package.json e package-lock.json
COPY package*.json ./

# Instalar as dependências
RUN npm install

# Copiar todos os arquivos para dentro do contêiner
COPY . .

# Expor a porta onde o backend vai rodar
EXPOSE 5000

# Comando para iniciar o servidor
CMD ["npm", "start"]
