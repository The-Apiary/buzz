Buzz.IndexRoute = Ember.Route.extend
  model: () ->
    Ember.RSVP.hash
      episodes: Buzz.Episode.find()
      subscriptions: Buzz.Subscription.find()
      queue: Buzz.QueuedEpisode.find()
