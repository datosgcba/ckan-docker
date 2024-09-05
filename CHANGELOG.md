Esta rama en particular usa una [imagen personalizada](https://hub.docker.com/repository/docker/ddecampos/ckan-2.10.4/general) de ckan-2.10.4, la cual contiene modificaciones para ser adaptable al plugin de BA Data ([ckanext-gobar-theme](https://github.com/datosgcba/ckanext-gobar-theme/tree/develop)).

A continuación se describen las modificaciones realizadas en la imagen base de [ckan 2.10.4](https://hub.docker.com/layers/ckan/ckan-base/2.10.4/images/sha256-3728a4d27fc18dfb41216423d220f67c492dc125c98c3ca99d29dc670885056f?context=explore):

1. Integración de paquete 'Routes':

```bash
pip install routes==2.5.1
```
    
```python
/ckan/plugins/interfaces.py:
...
  __all__ = [
      u'Interface',
      u'IRoutes',
      u'IMiddleware',
      u'IAuthFunctions',
      u'IDomainObjectModification',
      u'IFeed',
...
...
class IRoutes(Interface):
    u'''
    Plugin into the setup of the routes map creation.
    '''
    def before_map(self, map):
        u'''
        Called before the routes map is generated. ``before_map`` is before any
        other mappings are created so can override all other mappings.
        :param map: Routes map object
        :returns: Modified version of the map object
        '''
        return map

    def after_map(self, map):
        u'''
        Called after routes map is set up. ``after_map`` can be used to
        add fall-back handlers.
        :param map: Routes map object
        :returns: Modified version of the map object
        '''
        return map
...
```
```python
/ckan/tests/plugins/ckantestplugins.py:
...
class RoutesPlugin(p.SingletonPlugin):
    p.implements(p.IRoutes, inherit=True)

    def __init__(self, *args, **kw):
        self.calls_made = []

    def before_map(self, map):
        self.calls_made.append("before_map")
        return map

    def after_map(self, map):
        self.calls_made.append("after_map")
        return map
...
```

2. Integración de path "/oidc-pkce":
```python
source/ckan/config/middleware/common_middleware.py:
...
class HostHeaderMiddleware(object):
    '''
        Prevent the `Host` header from the incoming request to be used
        in the `Location` header of a redirect.
    '''
    def __init__(self, app: CKANApp):
        self.app = app

    def __call__(self, environ: Any, start_response: Any) -> Any:
        path_info = environ[u'PATH_INFO']
        if path_info in ['/login_generic', '/user/login/oidc-pkce',
                         '/user/logout', '/user/logged_in',
                         '/user/logged_out']:
            site_url = config.get('ckan.site_url')
            parts = urlparse(site_url)
            environ['HTTP_HOST'] = str(parts.netloc)
        return self.app(environ, start_response)
...
```