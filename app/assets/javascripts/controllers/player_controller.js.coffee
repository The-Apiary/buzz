Buzz.PlayerController = Ember.ObjectController.extend
  needs: 'queue'
  queueBinding: 'controllers.queue'
  is_playing: true
  player: null

  actions:
    play: ->
      this.get('player').play()
    pause: ->
      this.get('player').pause()
    skip: ->
      this.get('queue').remove(this.get 'model')
    mute: ->
      this.get('player').muted = true
    unmute: ->
      this.get('player').muted = false

    markPlayed: () ->
      current_episode = this.get 'model'
      # Mark the episode as played
      current_episode.update_is_played true, throttled: false
      # Delete the queued episode, removing it from the queue
      this.get('queue').remove(current_episode)

    setCurrentPosition: (position) ->
      this.get('model').update_current_position position

    setDuration: (duration) ->
      current_episode = this.get('model')
      current_duration = current_episode.get('duration')

      # Only save the new duration if the difference is greater than one.
      if current_duration < duration - 1 || current_duration > duration + 1
        current_episode.set('duration', duration)
        current_episode.save()
