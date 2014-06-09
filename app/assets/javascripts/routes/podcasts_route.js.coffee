#:: All Routes under the `podcast` resource

#Buzz.PodcastsRoute = Ember.Route.extend()
Buzz.PodcastsIndexRoute = Ember.Route.extend
  model: (params) ->
    this.store.find('podcast', popular: true)

#:: Show podcast route
Buzz.PodcastsShowRoute = Ember.Route.extend
  model: (params) ->
    this.store.find('podcast', params.id)

#:: New podcast route
#Buzz.PodcastsNewRoute = Ember.Route.extend
