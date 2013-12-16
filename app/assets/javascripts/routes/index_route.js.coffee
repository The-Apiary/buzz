Buzz.IndexRoute = Ember.Route.extend
  model: () ->
    Ember.RSVP.hash
      episodes: Buzz.Episode.find(limit:10)
      queue: Buzz.QueuedEpisode.find() # TODO: replace with actual queue load statement
