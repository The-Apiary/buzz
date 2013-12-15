Buzz.PodcastsRoute = Ember.Route.extend
  model: () ->
    Buzz.Podcast.find()
