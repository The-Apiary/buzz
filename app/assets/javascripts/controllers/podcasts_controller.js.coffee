#:: All Controllers under the `podcasts` resource.

#:: Unimplemented Podcasts controller (loaded for all podcasts controllers (show, new, ect.))
#Buzz.PodcastsController = Ember.ObjectController.extend()

#:: Unimplemented Podcasts Index Controller
#Buzz.PodcastsIndexController = Ember.ObjectController.extend()

#:: Podcasts Show Controller
Buzz.PodcastsShowController = Ember.ObjectController.extend

  type_options: [ 'Normal', 'Serial', 'News' ]

  type: ( (key, type)->
    if (type != undefined)
      subscription = this.get 'subscription'
      console.log subscription
      if subscription
        console.log 'stuff'
        subscription.set('subscription_type', type)
        subscription.save()
      return type
    else
      return this.get('subscription.subscription_type') || 'Normal'
  ).property('model', 'subscription', 'subscription.subscription_type')


  # Ember data won't load the hasMany relationship to episodes, so here it is
  # explicitly loaded.
  episodes: (() ->
      episodes = Buzz.Episode.find({podcast_id: this.get('model.id')})
  ).property('model')

  filtered_episodes: (->
    if this.get('type') == 'Normal'
      this.get('episodes').sortBy('publication_date').reverseObjects()
    else if this.get('type') == 'Serial'
      this.get('episodes').sortBy('publication_date')
    else if this.get('type') == 'News'
      this.get('episodes').filter (episode) ->
        one_week_in_ms = 1000 * 60 * 60 * 24 * 7
        episode.get('publication_date').getTime() > Date.now() - one_week_in_ms
  ).property('episodes', 'episodes.@each', 'type')

  # Checks whether the user is subscribed to the podcast.
  is_subscribed: (() ->
    subscription = this.get('subscription')
    return subscription != null
  ).property('model', 'subscription')

  actions:
    toggle_subscribe: ->
      if this.get('is_subscribed')
        this.send 'unsubscribe'
      else
        this.send 'subscribe'

    subscribe: ->
      subscription = Buzz.Subscription.createRecord podcast: this.get('model')
      subscription.save()

    unsubscribe: ->
      subscription = this.get('subscription')
      subscription.deleteRecord()
      subscription.save()

    set_type: (type) ->
      this.set('type', type.toString())

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
