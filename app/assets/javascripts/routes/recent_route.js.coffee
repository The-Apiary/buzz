Buzz.RecentRoute = Ember.Route.extend
  model: (podcast) ->
    Buzz.Episode.find()
