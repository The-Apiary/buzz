Buzz.SearchRoute = Ember.Route.extend
  model: (params) ->
    Ember.RSVP.hash
      query: params.query
      podcasts: $.getJSON "/api/v1/podcasts/search.json?q=#{params.query}"
      episodes: $.getJSON "/api/v1/episodes/search.json?q=#{params.query}"
