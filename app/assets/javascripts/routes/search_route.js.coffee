Buzz.SearchRoute = Ember.Route.extend
  model: (params) ->
    $.getJSON "/api/v1/search.json?q=#{params.query}"
