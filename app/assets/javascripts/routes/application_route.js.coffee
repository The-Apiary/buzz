Buzz.ApplicationRoute = Ember.Route.extend
  model: -> Buzz.QueuedEpisode.find()
