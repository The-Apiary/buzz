Buzz.EpisodesListenedRoute = Ember.Route.extend
  model: (podcast) ->
    this.store.find('episode', recently_listened: true)
