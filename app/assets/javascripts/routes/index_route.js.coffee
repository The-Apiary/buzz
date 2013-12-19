Buzz.IndexRoute = Ember.Route.extend
  model: () ->
    Ember.RSVP.hash
      podcasts: Buzz.Podcast.find()
      episodes: Buzz.Episode.find()
      queue: Buzz.QueuedEpisode.find()
