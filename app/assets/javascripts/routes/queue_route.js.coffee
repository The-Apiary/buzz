Buzz.QueueRoute = Ember.Route.extend
  model: () ->
    Buzz.Episode.find(limit: 3)
