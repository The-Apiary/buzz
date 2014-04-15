Buzz.EpisodeController = Ember.ObjectController.extend
  needs: 'queue'
  is_enqueued: (->
    this.get('controllers.queue').is_enqueued(this.get('id'))
  ).property('controllers.queue.queued_episodes.length')
  actions:
    remove: () ->
      this.get('controllers.queue').remove(this.get('model'))

    push: () ->
      this.get('controllers.queue').push(this.get('model'))

    unshift: () ->
      this.get('controllers.queue').unshift(this.get('model'))

    set_played: (bool) ->
      this.get('model').update_is_played bool, throttled: false

    reset: () ->
      this.get('model').reset()
