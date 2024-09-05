# CKAN Docker con BA Data
Este repositorio tiene el objetivo de desplegar el portal de datos abiertos de la Ciudad de Buenos Aires ([BA Data](https://data.buenosaires.gob.ar/)) en la aplicación de ckan versión [2.10.4](https://github.com/ckan/ckan/releases/tag/ckan-2.10.4).

Utilizamos docker como compilador com la intención de facilitar el despliegue de la aplicación con dos simples pasos:
```bash
    docker compose build
    docker compose up -d
```

Restore:
```bash
    docker exec -it <db-container-name> bash
    cd docker-entrypoint-initdb.d/
    psql -U ckandbuser -d ckandb -f ckan.sql
    psql -U ckandbuser -d datastore -f datastore.sql
```

Actualizar ckan db:
```bash
    docker exec -it <ckan-container-name> bash
    ckan search-index rebuild
```
