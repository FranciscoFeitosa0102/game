# Set the base image
FROM node:14

# Set working directory
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Expose the port
EXPOSE 3000

# Run the application
CMD ["npm", "start"]
