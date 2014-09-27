Buzz.SubscriptionsRoute = Ember.Route.extend
  model: () -> this.store.find('podcast', subscribed: true)
