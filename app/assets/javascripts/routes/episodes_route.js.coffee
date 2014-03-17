#:: All Routes under the `episodes` resource

#Buzz.EpisodesRoute = Ember.Route.extend()
#Buzz.EpisodesIndexRoute = Ember.Route.extend()

#:: Show podcast route
Buzz.EpisodesShowRoute = Ember.Route.extend
  model: (params) ->
    Buzz.Episode.find(params.id)
