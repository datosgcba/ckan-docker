# CKAN Docker con BA Data
Este repositorio tiene el objetivo de desplegar el portal de datos abiertos de la Ciudad de Buenos Aires ([BA Data](https://data.buenosaires.gob.ar/)) con una versión personalizada de [ckan 2.11.0](https://hub.docker.com/r/ddecampos/ckan-badata/tags).

## Instalación de Docker

Instala Docker siguiendo las siguientes instrucciones: [Instalar el motor Docker en Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

Para verificar que la instalación de Docker se ha realizado correctamente, ejecute `docker run hello-world` y `docker version`. Estos comandos deberían mostrar las versiones del cliente y del servidor.

## docker compose vs docker-compose

Todos los comandos de Docker Compose en este README utilizarán la versión V2 de Compose, es decir: `docker compose`. La versión anterior (V1) utilizaba el comando `docker-compose`. Para más información, consulte [Docker Compose](https://docs.docker.com/compose/compose-v2/).

## Instalar CKAN y sus dependencias

Copia el archivo `.env.example` y renómbralo a `.env`. Modifícalo según tus necesidades.

Utilizando los valores por defecto en el archivo `.env.example` obtendrá una instancia de CKAN funcionando. Hay un usuario sysadmin creado por defecto con los valores definidos en `CKAN_SYSADMIN_NAME` y `CKAN_SYSADMIN_PASSWORD` (`ckan_admin` y `test1234` por defecto). Esto debe ser obviamente cambiado antes de ejecutar esta configuración como una instancia pública de CKAN.

Para construir las imagenes:

	docker compose build

Para iniciar los contenedores:

	docker compose up -d

Al final de la secuencia de inicio de contenedores debe haber 6 contenedores en funcionamiento

![Screenshot 2022-12-12 at 10 36 21 am](https://user-images.githubusercontent.com/54408245/207012236-f9571baa-4d99-4ffe-bd93-30b11c4829e0.png)

Después de este paso, CKAN debería estar ejecutándose en `CKAN_SITE_URL`.

Actualizar ckan db:
```bash
docker exec -it <ckan-container-name> bash
ckan db upgrade
ckan search-index rebuild
```

## Modo de desarrollo

Para desarrollar extensiones locales usa el archivo `docker-compose.dev.yml`:

Para construir las imágenes

	docker compose -f docker-compose.dev.yml build

Para iniciar los contenedores:

	docker compose -f docker-compose.dev.yml up

Ver [CKAN Images](#ckan-images) para más detalles de lo que ocurre cuando se utiliza el modo de desarrollo.

### Crear una extensión

Puedes usar las instrucciones de ckan [extension](https://docs.ckan.org/en/latest/extensions/tutorial.html#creating-a-new-extension) para crear una extensión CKAN, sólo ejecutando el comando dentro del contenedor CKAN y estableciendo la carpeta `src/` montada como salida:

    docker compose -f docker-compose.dev.yml exec ckan-dev /bin/bash -c «ckan generate extension --output-dir /srv/app/src_extensions»

Los nuevos archivos y directorios de extensión se crearán en la carpeta `src/`. Es posible que tengas que cambiar el propietario de esta carpeta para que tenga los permisos adecuados.

## CKAN images
![ckan images](https://user-images.githubusercontent.com/54408245/207079416-a01235af-2dea-4425-b6fd-f8c3687dd993.png)

Los archivos de configuración de la imagen Docker utilizados para construir su proyecto CKAN se encuentran en la carpeta `ckan/`. Hay tres archivos Docker:

* `Dockerfile`: está basado en `ckan/ckan-base:<version>`, una imagen base localizada en el repositorio DockerHub, que tiene instalado CKAN junto con todas sus dependencias, correctamente configurado y ejecutándose en [uWSGI](https://uwsgi-docs.readthedocs.io/en/latest/) (configuración de producción).
* `Dockerfile.custom`: se utiliza para crear la imagen personalizada de ckan, en este caso para adaptarse a los requerimientos del plugin [ckanext-gobar-theme](https://github.com/datosgcba/ckanext-gobar-theme).
* `Dockerfile.dev`: está basado en `ckan/ckan-base:<version>-dev` también localizado en el repositorio DockerHub, y extiende `ckan/ckan-base:<version>` para incluir:

  * Cualquier extensión clonada en la carpeta `src` se instalará en el contenedor CKAN al arrancar Docker Compose (`docker compose up`). Esto incluye instalar cualquier requisito listado en un archivo `requirements.txt` (o `pip-requirements.txt`) y ejecutar `python setup.py develop`.
  * CKAN se inicia ejecutando esto: `/usr/bin/ckan -c /srv/app/ckan.ini run -H 0.0.0.0`.
  * Asegúrate de añadir los plugins locales a la var env `CKAN__PLUGINS` en el fichero `.env`.

