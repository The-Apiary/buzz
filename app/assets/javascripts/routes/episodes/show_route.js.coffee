#:: Show podcast route
Buzz.EpisodesShowRoute = Ember.Route.extend
  model: (params) ->
    this.store.find('episode', params.id)
