Buzz.SubscriptionsRoute = Ember.Route.extend
  model: () -> Buzz.Subscription.find()
