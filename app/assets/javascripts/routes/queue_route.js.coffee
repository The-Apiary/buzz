Buzz.QueueRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set('title', 'queue')
    controller.set('numbers', [1,2,3,4])
