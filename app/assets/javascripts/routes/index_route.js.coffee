Buzz.IndexRoute = Ember.Route.extend
  model: () ->
    Buzz.Episode.find()

