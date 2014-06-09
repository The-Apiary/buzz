Buzz.SearchRoute = Ember.Route.extend
  model: (params) ->
    Ember.RSVP.hash
      query: params.query
      podcasts: this.store.find('podcast', search: true, q: params.query)
      episodes: this.store.find('episode', search: true, q: params.query)
