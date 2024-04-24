### GitHub actions / Docker / Pipelines
---
<p align="justify">
Este proyecto utiliza Docker para crear una imagen del contenedor que contiene la aplicación web. Luego, se configura un pipeline en GitHub Actions para automatizar la actualización de la imagen de Docker. Cada vez que se realiza un commit en el repositorio, el pipeline se activa y crea una nueva versión del contenedor en Docker Hub con un tag superior al anterior. De esta manera, se asegura que la aplicación esté siempre actualizada y lista para ser desplegada en diferentes entornos.
</p>

---
     

<p align="center">
  <strong>Verificamos que...</strong>
</p>



<p align="justify">	
Este proyecto tiene un código fuente escrito en JavaScript (y posiblemente también HTML y CSS) que genera una página web. Utiliza React, una biblioteca de JavaScript para construir interfaces de usuario, y Create React App proporciona una estructura inicial y herramientas de desarrollo para facilitar la creación de la aplicación web.
</p>

<p align="center">
Si ejecutamos nuestra aplicación, obtendríamos este resultado. 👍🏼👍🏼
</p>


<p align="center">
  <img src="https://github.com/Sebastianavia/ci-github-2024-1/assets/71205906/a69d7c31-f584-48d3-987a-95bfaba70ca7" width="400" alt="Descripción de la imagen">
</p>
---

### Docker:

Crearemos un Dockerfile en la raíz del proyecto para contenerizar la aplicación.

```
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


```

---

### GitHub Actions

<p align="justify">
Para automatizar el proceso de contenerización y despliegue de la aplicación, vamos a utilizar GitHub Actions. Este servicio nos permite definir flujos de trabajo automatizados que se activan en respuesta a eventos específicos, como confirmaciones de código o actualizaciones de repositorios.

A continuación, se presenta el archivo YAML de configuración de GitHub Actions, el cual define el flujo de trabajo que será ejecutado:



</p>

    name: Docker Image CI

    on:
    push:
        branches: [ "main" ]
    pull_request:
        branches: [ "main" ]

    jobs:

    build:

        runs-on: ubuntu-latest

        steps:
        - name: Checkout
        uses: actions/checkout@v2 # Specify the version of the checkout action
        
        - name: Build the Docker image
        run: docker build . --file Dockerfile -t sebastiannavia/appnode1:${{ github.run_number }}
        # Use github.run_number to tag the Docker image with a unique identifier
        
        - name: Docker Login
        uses: docker/login-action@v2
        with:
            username: ${{ secrets.DOCKER_USERNAME }}
            password: ${{ secrets.DOCKER_PASSWORD }}

        - name: Push into Docker-hub
        run: docker push sebastiannavia/appnode1:${{ github.run_number }}
        # Use github.run_number to reference the same tag used during build





**Nombre del flujo de trabajo:** Docker Image CI
- Eventos desencadenantes:
Se ejecutará cuando se realicen push o pull requests en la rama main.
	* **Trabajos:**
		* **build:** Define que se ejecutará en una máquina virtual con Ubuntu.
		* **Pasos:**
			1. **Checkout:** Obtiene el código fuente del repositorio.
			2. **Construir la imagen Docker:** Utiliza el archivo Dockerfile para construir una imagen Docker. La imagen se etiqueta con un identificador único generado por github.run_number.

			3. **Inicio de sesión en Docker:** Utiliza las credenciales almacenadas en los secretos de GitHub para iniciar sesión en Docker Hub.
			4. **Subida a Docker Hub:** Sube la imagen Docker a Docker Hub, utilizando la etiqueta generada previamente por github.run_number.

Este flujo de trabajo automatizado facilita la integración continua y el despliegue de la imagen Docker en Docker Hub cada vez que se realizan cambios en la rama main.

