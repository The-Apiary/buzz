Buzz.EpisodesLatestRoute = Ember.Route.extend
  model: (podcast) ->
    this.store.find('episode', recently_published: true)
