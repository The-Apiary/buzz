Buzz.CategoriesIndexRoute = Ember.Route.extend
  model: () ->
    this.store.find('category')

Buzz.CategoriesShowRoute = Ember.Route.extend
  model: (params) ->
    this.store.find('category', params.name)
