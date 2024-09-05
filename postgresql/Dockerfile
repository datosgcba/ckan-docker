FROM postgres:12-alpine

# Include extra setup scripts (eg datastore)
COPY --chown=postgres:postgres docker-entrypoint-initdb.d /docker-entrypoint-initdb.d

# Copiamos los dumps a una carpeta dentro del contenedor
COPY dumps/ /docker-entrypoint-initdb.d/
