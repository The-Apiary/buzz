# http://emberjs.com/guides/models/using-the-store/

DS.RESTAdapter.reopen
  namespace: 'api/v1'

Buzz.Store = DS.Store.extend
  revision: 11,
  adapter: DS.RESTAdapter.create()
