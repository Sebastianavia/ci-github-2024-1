# Utilizamos una imagen base con Node.js
FROM node:latest

# Establecemos el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiamos los archivos de configuración y dependencias del proyecto
COPY package.json package-lock.json ./
COPY public ./public
COPY src ./src

# Instalamos las dependencias del proyecto
RUN npm install
RUN npm run build
CMD ["npm","run","dev"]

# Exponemos el puerto en el que se ejecutará la aplicación (por defecto, 3000)
EXPOSE 3000

# Comando para ejecutar la aplicación
CMD ["npm", "start"]
