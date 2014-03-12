#:: All Routes under the `podcast` resource

#Buzz.PodcastRoute = Ember.Route.extend()
#Buzz.PodcastIndexRoute = Ember.Route.extend()

#:: Show podcast route
Buzz.PodcastShowRoute = Ember.Route.extend
  model: (params) ->
    Buzz.Podcast.find(params.id)

#:: New podcast route
#Buzz.PodcastNewRoute = Ember.Route.extend
