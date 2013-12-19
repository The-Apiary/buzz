Buzz.IndexRoute = Ember.Route.extend
  model: () ->
    Ember.RSVP.hash
      episodes: Buzz.Episode.find(limit: 10)
      podcasts: Buzz.Podcast.find()
      queue: Buzz.QueuedEpisode.find()
