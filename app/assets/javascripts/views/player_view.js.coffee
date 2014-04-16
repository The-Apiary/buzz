Buzz.PlayerView = Ember.View.extend
  templateName: 'player'

  # Add hooks to update control state
  bindControlEvents: (player) ->
    self = this
    player.addEventListener 'play', () ->
      self.set 'controller.is_playing', true

    player.addEventListener 'pause', () ->
      self.set 'controller.is_playing', false

    player.addEventListener 'volumechange', () ->
      self.set 'controller.is_muted', player.muted
      self.set 'controller.volume', player.volume

  # Update current positon, duration, and next track actions.
  bindEpisodeDataUpdate: (player) ->
    self = this
    # Set the current position in the current track
    player.addEventListener 'timeupdate', () ->
      if self.get('controller')
        self.get('controller').send('setCurrentPosition', this.currentTime)

    # Set the current tracks durration
    player.addEventListener 'durationchange', () ->
      if self.get('controller')
        self.get('controller').send('setDuration', this.duration)

    # Resume playback from previous position
    player.addEventListener 'canplay', _.once ->
      currentTime = self.get('controller.model.current_position')
      player.currentTime = currentTime if currentTime

    # play next track
    player.addEventListener 'ended', () ->
      self.get('controller').send('markPlayed')



  didInsertElement: () ->
    player = this.$('audio')[0]
    this.set 'controller.player', player

    this.bindControlEvents(player)
    this.bindEpisodeDataUpdate(player)

    if player.paused
      this.set 'controller.is_playing', false


  willDestroyElement: () ->
    player = this.$('audio')[0]
    player.removeEventListener 'ended'

