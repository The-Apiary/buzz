Buzz.EpisodesRoute = Ember.Route.extend
  model: () ->
    Buzz.Episode.find()
