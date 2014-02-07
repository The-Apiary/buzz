# http://emberjs.com/guides/models/using-the-store/

DS.RESTAdapter.reopen
  namespace: 'api/v1'

Buzz.Adapter = DS.RESTAdapter.create()

Buzz.Store = DS.Store.extend
  adapter: Buzz.Adapter
