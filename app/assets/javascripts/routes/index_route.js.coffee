Buzz.IndexRoute = Ember.Route.extend
  model: () ->
    Ember.RSVP.hash
      episodes: Buzz.Episode.find(limit:10)
      queue: Buzz.Episode.find(limit:2) # TODO: replace with actual queue load statement
