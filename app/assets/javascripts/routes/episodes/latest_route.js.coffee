Buzz.EpisodesLatestRoute = Ember.Route.extend
  model: (podcast) ->
    Buzz.Episode.find({recently_published: true})
