Buzz.EpisodesRoute = Ember.Route.extend
  model: (podcast) ->
    Buzz.Episode.find(podcat_id: podcast.id)
