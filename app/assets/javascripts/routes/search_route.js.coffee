Buzz.SearchRoute = Ember.Route.extend
  model: (params) ->
    Ember.RSVP.hash
      query: params.query
      results: $.getJSON "/api/v1/search.json?q=#{params.query}"
