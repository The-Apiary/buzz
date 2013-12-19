Buzz.IndexRoute = Ember.Route.extend
  model: () ->
    Ember.RSVP.hash
      episodes: Buzz.Episode.find()
      podcasts: Buzz.Podcast.find()
      queue: Buzz.QueuedEpisode.find()
