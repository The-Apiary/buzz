Buzz.EpisodeRoute = Ember.Route.extend
  setupController: (controller, episode) ->
    controller.set('model', episode)

