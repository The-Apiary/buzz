Buzz.IndexRoute = Ember.Route.extend
  model: () ->
    Ember.RSVP.hash
      episodes: Buzz.Episode.find()
      episode_datas: Buzz.EpisodeData.find()
      podcasts: Buzz.Podcast.find()
      queue: Buzz.QueuedEpisode.find()
