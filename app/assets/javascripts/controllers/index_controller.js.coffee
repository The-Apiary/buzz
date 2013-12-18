Buzz.IndexController = Ember.ObjectController.extend
  displayed_episodes: (->
    this.get('model.episodes').filterBy('is_played', false)
  ).property('model.episodes.@each.is_played')

