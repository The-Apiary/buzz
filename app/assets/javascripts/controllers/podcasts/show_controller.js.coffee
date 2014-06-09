#:: Podcasts Show Controller
Buzz.PodcastsShowController = Ember.ObjectController.extend
  type_options: [ 'Normal', 'Serial', 'News' ]

  type: ( (key, type)->
    if (type != undefined)
      this.get('subscription').then (subscription) =>
        if subscription
          subscription.set('subscription_type', type)
          subscription.save()
      return type
    else
      return this.get('subscription.subscription_type') || 'Normal'
  ).property('model', 'subscription', 'subscription.subscription_type')


  # Ember data won't load the hasMany relationship to episodes, so here it is
  # explicitly loaded.
  episodes: (() ->
    episodes = this.store.find('episode', podcast_id: this.get('model.id'))
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
  ).property('model', 'model.subscription')

  actions:
    toggle_subscribe: ->
      if this.get('is_subscribed')
        this.send 'unsubscribe'
      else
        this.send 'subscribe'

    subscribe: ->
      subscription = this.store.createRecord('subscription', podcast: this.get('model'))
      subscription.save().then (sub) => this.set('subscription', sub)

    unsubscribe: ->
      this.get('subscription').then (subscription) =>
        subscription.deleteRecord()
        subscription.save().then () => this.set('subscription', undefined)

    set_type: (type) ->
      this.set('type', type.toString())
