#:: All Controllers under the `podcast` resource.

#:: Unimplemented Podcast controller (loaded for all podcast controllers (show, new, ect.))
#Buzz.PodcastController = Ember.ObjectController.extend()

#:: Unimplemented Podcast Index Controller
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
      subscription = this.get('subscription')
      subscription.deleteRecord()
      subscription.save()

#:: Podcast New Controller
Buzz.PodcastNewController = Ember.ObjectController.extend
  feed_url: null
  errors: []

  feedback: (->
    console.log this.get('errors.length') > 0
    if this.get('errors.length') > 0
      return 'has-feedback has-error'
    else
      return ''
  ).property('errors', 'errors.@each')

  actions:

    create: ->
      podcast = Buzz.Podcast.createRecord feed_url: this.get('feed_url')
      podcast.save().then(
        ( (podcast) => this.transitionToRoute('podcast.show', podcast) ),
        ( (podcast) =>
          errors = _.chain(podcast.errors).map( (messages, attr) ->
            (messages).map (message) ->
              "#{attr} #{message}"
          ).flatten().value()

          this.set('errors', errors)
        )
      )
