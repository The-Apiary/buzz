Buzz.PlayerView = Ember.View.extend
  templateName: 'player'

  # Add hooks to update control state
  bindControlEvents: (player, dispatcher) ->
    self = this

    id_hash = $('#user').data('id-hash')
    channel = dispatcher.subscribe(id_hash)

    # Send an event to the controller and the socket.
    addDispatchedEvent = (event, message_cb) ->
      channel.bind "receive.#{event}", (message) ->
        self.get('controller').send("receive_#{event}", message)

      player.addEventListener event, () ->
        message = if _.isFunction(message_cb) then message_cb() else {}
        dispatcher.trigger "receive.#{event}", message
        self.get('controller').send("receive_#{event}", message)

    addDispatchedEvent 'play'

    addDispatchedEvent 'pause'

    addDispatchedEvent 'volumechange', () ->
      { muted: player.muted, volume: player.volume }

    addDispatchedEvent 'progress', () ->
        # The end of the last buffered segment
        buffered_chunks = player.buffered.length
        if buffered_chunks > 0
          buffered = player.buffered.end(buffered_chunks - 1)
        else
          buffered = 0
        return {buffered: buffered}

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

    websocket_uri = $('#websocket').data('uri')
    dispatcher = new WebSocketRails(websocket_uri)

    player = self.$('audio')[0]

    # Add player and dispatcher to the controller.
    self.set 'controller.player', player

    # Set the pages title to the episode title.
    $(document).attr 'title', self.get('controller.model.title')

    self.bindControlEvents(player, dispatcher)
    self.bindEpisodeDataUpdate(player, dispatcher)

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

    # Unset the pages title.
    $(document).attr 'title', 'Buzz'
