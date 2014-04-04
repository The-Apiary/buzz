Buzz.CategoriesIndexRoute = Ember.Route.extend
  model: () ->
    Buzz.Category.find()

Buzz.CategoriesShowRoute = Ember.Route.extend
  model: (params) ->
    Buzz.Category.find(params.name)
