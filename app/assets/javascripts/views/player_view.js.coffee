Buzz.PlayerView = Ember.View.extend
  templateName: 'player'

  didInsertElement: () ->
    self = this
    player = this.$('audio')[0]
    self.set 'controller.player', player

    player.addEventListener 'loadstart', (event) ->
      console.log 'loadstart'

    player.addEventListener 'stalled', (event) ->
      console.log 'stalled'

    # Resume playback from previous position
    player.addEventListener 'canplay', (event) ->
      currentTime = self.get('controller.current_episode.current_position')
      player.currentTime = currentTime

    player.addEventListener 'play', (event) ->
      self.set 'controller.is_playing', true

    player.addEventListener 'pause', (event) ->
      self.set 'controller.is_playing', false

    player.addEventListener 'volumechange', (event) ->
      self.set 'controller.is_muted', player.muted
      self.set 'controller.volume', player.volume

    # Set the current position in the current track
    player.addEventListener 'timeupdate', (event) ->
      if self.get('controller')
        self.get('controller').send('setCurrentPosition', this.currentTime)


    # Set the current tracks durration
    player.addEventListener 'durationchange', (event) ->
      if self.get('controller')
        self.get('controller').send('setDuration', this.duration)

    # play next track
    player.addEventListener 'ended', (event) ->
      self.get('controller').send('markPlayed')
  willDestroyElement: () ->
    player = this.$('audio')[0]
    player.removeEventListener 'ended'

