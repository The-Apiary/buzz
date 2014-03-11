#:: All Routes under the `podcast` resource

#Buzz.PodcastRoute = Ember.Route.extend()
#Buzz.PodcastIndexRoute = Ember.Route.extend()

#:: Podcast Show Route
Buzz.PodcastShowRoute = Ember.Route.extend
  model: (params) ->
    Buzz.Podcast.find(params.id)

#Buzz.PodcastNewRoute = Ember.Route.extend()
