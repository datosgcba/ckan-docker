# CKAN Docker con BA Data
Este repositorio tiene el objetivo de desplegar el portal de datos abiertos de la Ciudad de Buenos Aires ([BA Data](https://data.buenosaires.gob.ar/)) en la aplicación de ckan versión [2.10.4](https://github.com/ckan/ckan/releases/tag/ckan-2.10.4).

Utilizamos docker como compilador com la intención de facilitar el despliegue de la aplicación con dos simples pasos:

    docker compose build
    docker compose up -d

Restore:

    docker exec -it <db-container-name> bash
    cd docker-entrypoint-initdb.d/
    psql -U ckandbuser -d ckandb -f ckan.sql
    psql -U ckandbuser -d datastore -f datastore.sql

Actualizar ckan db:

    docker exec -it <ckan-container-name> bash
    ckan search-index rebuild

Esta rama en particular usa una [imagen personalizada](https://hub.docker.com/repository/docker/ddecampos/ckan-2.10.4/general) de ckan-2.10.4, la cual contiene modificaciones para ser adaptable al plugin de BA Data ([ckanext-gobar-theme](https://github.com/datosgcba/ckanext-gobar-theme/tree/develop)).

A continuación se describen las modificaciones realizadas en la imagen base de [ckan 2.10.4](https://hub.docker.com/layers/ckan/ckan-base/2.10.4/images/sha256-3728a4d27fc18dfb41216423d220f67c492dc125c98c3ca99d29dc670885056f?context=explore):

1. Instalación de paquete 'Routes':
```
pip install routes==2.5.1
```

2. /ckan/lib/helpers.py:
```
...
+@maintain.deprecated('h.url is deprecated please use h.url_for')
+@core_helper
+def url(*args, **kw):
+    '''
+    Deprecated: please use `url_for` instead
+    '''
+    return url_for(*args, **kw)
...
```

3. /ckan/plugins/interfaces.py:
```
...
  __all__ = [
      u'Interface',
+     u'IRoutes',
      u'IMiddleware',
      u'IAuthFunctions',
      u'IDomainObjectModification',
      u'IFeed',
...
...
+class IRoutes(Interface):
+    u'''
+    Plugin into the setup of the routes map creation.
+    '''
+    def before_map(self, map):
+        u'''
+        Called before the routes map is generated. ``before_map`` is before any
+        other mappings are created so can override all other mappings.
+        :param map: Routes map object
+        :returns: Modified version of the map object
+        '''
+        return map
+
+    def after_map(self, map):
+        u'''
+        Called after routes map is set up. ``after_map`` can be used to
+        add fall-back handlers.
+        :param map: Routes map object
+        :returns: Modified version of the map object
+        '''
+        return map
...
```
4. /ckan/tests/plugins/ckantestplugins.py
```
...
+class RoutesPlugin(p.SingletonPlugin):
+    p.implements(p.IRoutes, inherit=True)
+
+    def __init__(self, *args, **kw):
+        self.calls_made = []
+
+    def before_map(self, map):
+        self.calls_made.append("before_map")
+        return map
+
+    def after_map(self, map):
+        self.calls_made.append("after_map")
+        return map
...
```