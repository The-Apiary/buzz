#:: All Controllers under the `podcasts` resource.

#:: Unimplemented Podcasts controller (loaded for all podcasts controllers (show, new, ect.))
#Buzz.PodcastsController = Ember.ObjectController.extend()

#:: Unimplemented Podcasts Index Controller
#Buzz.PodcastsIndexController = Ember.ObjectController.extend()

#:: Podcasts Show Controller
Buzz.PodcastsShowController = Ember.ObjectController.extend

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

#:: Podcasts New Controller
Buzz.PodcastsNewController = Ember.ObjectController.extend
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
        ( (podcast) => this.transitionToRoute('podcasts.show', podcast) ),
        ( (podcast) =>
          errors = _.chain(podcast.errors).map( (messages, attr) ->
            (messages).map (message) ->
              "#{attr} #{message}"
          ).flatten().value()

          this.set('errors', errors)
        )
      )
