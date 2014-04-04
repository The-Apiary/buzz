Buzz.SubscriptionsRoute = Ember.Route.extend
  model: () -> Buzz.Podcast.find(subscribed: true)
