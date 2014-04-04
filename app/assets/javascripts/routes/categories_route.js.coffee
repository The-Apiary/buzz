Buzz.CategoriesRoute = Ember.Route.extend
  model: (params) ->
    Buzz.Category.find(params.name)
