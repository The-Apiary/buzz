Buzz.ApplicationRoute = Ember.Route.extend
  model: ->
    Buzz.Subscription.find()
