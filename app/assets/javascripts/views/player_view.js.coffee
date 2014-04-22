Buzz.PlayerView = Ember.View.extend
  templateName: 'player'

  # Add hooks to update control state
  bindControlEvents: (player) ->
    self = this
    player.addEventListener 'play', () ->
      if self.get('controller')
        self.set 'controller.is_playing', true

    player.addEventListener 'pause', () ->
      if self.get('controller')
        self.set 'controller.is_playing', false

    player.addEventListener 'volumechange', () ->
      if self.get('controller')
        self.set 'controller.is_muted', player.muted
        self.set 'controller.volume', player.volume

    # Update buffered attribute
    player.addEventListener 'progress', () ->
      # The end of the last buffered segment
      length = player.buffered.length
      if length > 0
        buffered = player.buffered.end(length - 1)
      else
        buffered = 0
      if self.get('controller')
        self.set('controller.buffered', buffered)

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

    player.addEventListener 'stalled', () ->
      console.log 'stalled'

    # Resume playback from previous position
    player.addEventListener 'canplay', _.once ->
      currentTime = self.get('controller.model.current_position')
      player.currentTime = currentTime if currentTime

    # play next track
    player.addEventListener 'ended', () ->
      self.get('controller').send('markPlayed')



  didInsertElement: () ->
    self = this
    player = self.$('audio')[0]
    self.set 'controller.player', player

    self.bindControlEvents(player)
    self.bindEpisodeDataUpdate(player)

    if player.paused
      self.set 'controller.is_playing', false

    scrubber = self.$('.scrubber')

    # Bind seek events to the scrubber
    scrubber.bind 'click', (e) ->
      pos = e.clientX - e.currentTarget.getBoundingClientRect().left
      width = e.currentTarget.clientWidth
      self.get('controller').send('seek', pos/width)


  willDestroyElement: () ->
    player = this.$('audio')[0]
    player.removeEventListener 'ended'
