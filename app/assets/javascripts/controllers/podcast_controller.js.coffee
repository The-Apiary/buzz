#:: All Controllers under the `podcast` resource.

#Buzz.PodcastController = Ember.ObjectController.extend()
#Buzz.PodcastIndexController = Ember.ObjectController.extend()

#:: Podcast Show Controller
Buzz.PodcastShowController = Ember.ObjectController.extend
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
      subscription = Buzz.Subscription.createRecord podcast: this.get('model')
      subscription.save()
    unsubscribe: ->
      #Unsubscribe code here
      subscription = this.get('subscription')
      subscription.deleteRecord()
      subscription.save()

Buzz.PodcastNewController = Ember.ObjectController.extend
  feed_url: null
  actions:
    create: ->
      console.log this.get('feed_url')
