Buzz.PlayerController = Ember.ObjectController.extend
  needs: 'queue'
  queueBinding: 'controllers.queue'
  player: null

  is_playing: true
  buffered: 0
  currentTime: 0

  percent_listened: (->
    return (this.get('currentTime') / this.get('duration')) * 100
  ).property('currentTime')

  percent_listened_width: (->
    listened = this.get 'percent_listened'

    return "width: #{listened}%;"
  ).property('currentTime')

  percent_buffered_width: (->
    listened = this.get 'percent_listened'
    buffered = (this.get('buffered') / this.get('duration')) * 100

    return "width: #{buffered - (listened + 0.2)}%;"
  ).property('buffered', 'percent_listened')


  actions:
    play: ->
      this.get('player').play()
      return false

    pause: ->
      this.get('player').pause()
      return false

    skip: ->
      this.get('queue').remove(this.get 'model')
      return false

    mute: ->
      this.get('player').muted = true
      return false

    unmute: ->
      this.get('player').muted = false
      return false

    seek: (perc) ->
      currentTime = this.get('player').duration * perc

      this.set 'currentTime', currentTime
      this.get('player').currentTime = currentTime
      return false

    markPlayed: () ->
      current_episode = this.get 'model'
      # Mark the episode as played
      current_episode.update_is_played true, throttled: false
      # Delete the queued episode, removing it from the queue
      this.get('queue').remove(current_episode)

    setCurrentPosition: (currentTime) ->
      this.set('currentTime', currentTime)
      this.get('model').update_current_position currentTime

    setDuration: (duration) ->
      current_episode = this.get('model')
      current_duration = current_episode.get('duration')

      # Only save the new duration if the difference is greater than one.
      if current_duration < duration - 1 || current_duration > duration + 1
        current_episode.set('duration', duration)
        current_episode.save()
