Buzz.SubscriptionsRoute = Ember.Route.extend
  model: () -> this.store.find('podcast', subscribed: true)

Buzz.SubscriptionsUserRoute = Ember.Route.extend
  controllerName: 'subscriptions'
  model: (params) ->
    this.store.find('podcast', subscribed: true, user: params.id)
