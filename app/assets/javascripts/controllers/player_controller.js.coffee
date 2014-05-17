Buzz.PlayerController = Ember.ObjectController.extend
  needs: 'queue'
  queueBinding: 'controllers.queue'
  player: null

  is_playing: true
  buffered: 0
  currentTime: 0

  percent_listened: (->
    listened = (this.get('currentTime') / this.get('duration')) * 100
    listened = 100 if listened > 100
    return listened
  ).property('currentTime')

  percent_listened_width: (->
    listened = this.get 'percent_listened'

    return "width: #{listened}%;"
  ).property('currentTime')

  percent_buffered_width: (->
    listened = this.get 'percent_listened'
    buffered = (this.get('buffered') / this.get('duration')) * 100

    buffered = 100 if buffered > 100

    return "width: calc(#{buffered}% - #{listened}% - 1px);"
  ).property('buffered', 'percent_listened')


  actions:
    audio_play: ->
      this.set 'is_playing', true
      return false
    audio_pause: ->
      this.set 'is_playing', false
      return false
    audio_volumechange: (message) ->
      this.set 'is_muted', message.muted
      this.set 'volume', message.volume
      return false
    audio_progress: (message) ->
      this.set('buffered', message.buffered)
      return false

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
      ce = this.get 'model'
      # Mark the episode as played
      data = { is_played: true, current_position: this.get('currentTime') }
      options = { throttled: false }
      ce.update_episode_data data, options

      # Delete the queued episode, removing it from the queue
      this.get('queue').remove(ce)

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
