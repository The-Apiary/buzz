#:: Show podcast route
Buzz.EpisodesShowRoute = Ember.Route.extend
  model: (params) ->
    Buzz.Episode.find(params.id)
