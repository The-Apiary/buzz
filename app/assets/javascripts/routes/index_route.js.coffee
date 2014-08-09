Buzz.IndexRoute = Ember.Route.extend
  redirect: -> this.transitionTo 'episodes.suggestions'
