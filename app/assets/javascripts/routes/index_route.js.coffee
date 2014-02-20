Buzz.IndexRoute = Ember.Route.extend
  model: -> Buzz.QueuedEpisode.find()
