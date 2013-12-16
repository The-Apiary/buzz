Buzz.EpisodesRoute = Ember.Route.extend
  model: () ->
    Buzz.Episode.find(limit: 10)
