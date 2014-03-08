Buzz.PodcastController = Ember.ObjectController.extend
  # Ember data won't load the hasMany relationship to episodes, so here it is
  # explicitly loaded.
  episodes: (() ->
      episodes = Buzz.Episode.find({podcast_id: this.get('model.id')})
  ).property('model')
  #Checks whether the user is subscribed to the podcast.
  is_subscribed: (() ->
    subscription = this.get('subscription')
  ).property('model', 'subscription')
  actions:
    subscribe: ->
      #Subscribe code here
      subscription = Buzz.Subscription.createRecord podcast: this.get('model')
      subscription.save()
    unsubscribe: ->
      #Unsubscribe code here
