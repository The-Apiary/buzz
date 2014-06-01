Buzz.PlayerController = Ember.ObjectController.extend
  needs: 'queue'
  queueBinding: 'controllers.queue'

  # Websocket info
  dispatcher:       null
  events_channel:   null
  commands_channel: null

  # Player info
  pplayer: null
  player: ((attr, player) ->
    if player != undefined
      this.send 'unbind_events'
      this.set 'pplayer', player
      this.send 'bind_events', player
      return player
    else
      return null
  ).property('player')

  local_playback: null


  # State
  is_playing:  false
  buffered:    0
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
    # Add hooks to update control state
    bind_events:  (player) ->
      self = this
      events = ['play', 'pause', 'stalled', 'volumechange',
         'durationchange', 'progress', 'timeupdate']

      _(events).each (event) ->
        player.bind event, (message) -> self.send('event', event, message)

    unbind_events: ->
      self = this

      player = self.get 'player'
      player.destroy() if player

    create_remote_player: ->
      dispatcher        = this.get('dispatcher')
      events_channel_id = this.get('events_channel_id')

      dispatcher.trigger 'release_local_player'

      player = new Buzz.RemotePlayer(dispatcher, events_channel_id)

      this.set 'player', player
      this.set 'local_playback', false

    create_local_player: ->

      audio_url = this.get 'audio_url'

      connection_id    = this.get('connection_id')
      dispatcher = this.get('dispatcher')
      commands_channel_id = this.get('commands_channel_id')

      dispatcher.trigger 'claim_local_player'

      player = new Buzz.LocalPlayer(
        dispatcher, commands_channel_id, audio_url)

      this.set 'player', player
      this.set 'local_playback', true


    event: (event, message) ->
      switch event
        when 'stalled'
          console.log 'stalled'
        when 'play'
          this.set 'is_playing', true
        when 'pause'
          this.set 'is_playing', false
        when 'volumechange'
          this.set 'is_muted', message.muted
          this.set 'volume', message.volume
        when 'progress'
          this.set('buffered', message.buffered)
        when 'timeupdate'
          this.set('currentTime', message.currentTime)
          this.get('model').update_current_position message.currentTime
        when 'durationchange'
          current_episode = this.get('model')
          current_duration = current_episode.get('duration')
          duration = message.duration

          # Only save the new duration if the difference is greater than one.
          if current_duration < duration - 1 || current_duration > duration + 1
            current_episode.set('duration', duration)
            current_episode.save()

      # Return false to stop event propagation.
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
      this.get('player').mute()
      return false

    unmute: ->
      this.get('player').unmute()
      return false

    seek: (perc) ->
      this.get('player').seek(perc)
      return false

    markPlayed: () ->
      ce = this.get 'model'
      # Mark the episode as played
      data = { is_played: true, current_position: this.get('currentTime') }
      options = { throttled: false }
      ce.update_episode_data data, options

      # Delete the queued episode, removing it from the queue
      this.get('queue').remove(ce)
