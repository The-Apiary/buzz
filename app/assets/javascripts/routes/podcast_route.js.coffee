Buzz.PodcastRoute = Ember.Route.extend
  model: (params) -> 
    Buzz.Podcast.find(params.id)

