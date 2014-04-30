Buzz.EpisodesListenedRoute = Ember.Route.extend
  model: (podcast) ->
    Buzz.Episode.find({recently_listened: true})
