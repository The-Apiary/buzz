Buzz.SearchRoute = Ember.Route.extend
  model: (params) ->
    Ember.RSVP.hash
      query: params.query
      podcasts: Buzz.Podcast.find(search: true, q: params.query)
      episodes: Buzz.Episode.find(search: true, q: params.query)
