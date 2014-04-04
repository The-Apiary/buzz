#:: All Routes under the `podcast` resource

#Buzz.PodcastsRoute = Ember.Route.extend()
Buzz.PodcastsIndexRoute = Ember.Route.extend
  model: (params) ->
    Buzz.Podcast.find(popular: true)

#:: Show podcast route
Buzz.PodcastsShowRoute = Ember.Route.extend
  model: (params) ->
    Buzz.Podcast.find(params.id)

#:: New podcast route
#Buzz.PodcastsNewRoute = Ember.Route.extend
