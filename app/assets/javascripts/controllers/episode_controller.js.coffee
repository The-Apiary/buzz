Buzz.EpisodeController = Ember.ObjectController.extend
  needs: ['queue', 'player']
  is_enqueued: (->
    this.get('controllers.queue').is_enqueued(this.get('id'))
  ).property('controllers.queue.queued_episodes.length')

  add_episode_to_queue: (method, episode) ->
    valid_methods = ['push', 'unshift', 'play']
    if valid_methods.indexOf(method) >= 0

      # If the episode was nearly finished start the episode from the
      # beginning.
      time_left = this.get('duration') - this.get('current_position')
      if time_left < 10
        this.get('model').reset()

      # Add the episode to the queue.
      this.get("controllers.queue")[method](episode)
    else
      throw "Invalid method #{method}, must be one of #{valid_methods}."

  actions:
    remove: () ->
      this.get('controllers.queue').remove(this.get('model'))
      return null

    push: () ->
      this.add_episode_to_queue('push', this.get('model'))
      return null

    unshift: () ->
      this.add_episode_to_queue('unshift', this.get('model'))
      return null

    # Play is a different method than push because it may be different
    # in the future. Specifically once the audio controls are improved
    # the play action will unpause the player.
    play: () ->
      this.add_episode_to_queue('push', this.get('model'))
      return null

    set_played: (bool) ->
      this.get('model').update_is_played bool, throttled: false
      return null

    reset: () ->
      this.get('model').reset()
      return null
