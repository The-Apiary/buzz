Buzz.EpisodesLatestRoute = Ember.Route.extend
  model: () ->
    this.store.find('episode', recently_published: true)
