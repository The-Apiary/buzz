Buzz.ApplicationRoute = Ember.Route.extend
  model: ->
    Buzz.Podcast.find()
