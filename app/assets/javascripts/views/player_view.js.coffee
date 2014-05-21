Buzz.PlayerView = Ember.View.extend
  templateName: 'player'

  # Add hooks to update control state
  bindControlEvents: (player, dispatcher, client_id) ->
    self = this

    # Listen for events from the master on the users channel
    id_hash = $('#user').data('id-hash')
    channel = dispatcher.subscribe(id_hash)
    rel = new Buzz.RemoteEventListener(self.get('controller'), channel, 'event')

    events = ['play', 'pause', 'stalled', 'volumechange',
              'durationchange', 'progress', 'timeupdate']

    _(events).each (basic_event) -> rel.bind basic_event

    ## Master Only

    # Emit events for other clients to capture.
    led = new Buzz.LocalEventDispatcher(player, dispatcher, 'event')

    # Bind basic events, those without messages.
    _(['play', 'pause', 'stalled']).each (basic_event) ->
      led.addDispatchedEvent basic_event

    # Mute/unmute or change the volume
    led.addDispatchedEvent 'volumechange', () ->
      { muted: player.muted, volume: player.volume }

    # Set the current tracks duration
    led.addDispatchedEvent 'durationchange', () ->
      { duration: player.duration }

    # Update the controllers buffered value
    # Send the events no less than a second apart
    led.addThrottledDispatchedEvent 'progress', 1000, () ->
        # The end of the last buffered segment
        buffered_chunks = player.buffered.length
        if buffered_chunks > 0
          buffered = player.buffered.end(buffered_chunks - 1)
        else
          buffered = 0
        return {buffered: buffered}

    # Update the controllers currentTime value
    # Send the events no less than a second apart
    led.addThrottledDispatchedEvent 'timeupdate', 1000, () ->
      { currentTime: player.currentTime }



  # Update current positon, duration, and next track actions.
  bindEpisodeDataUpdate: (player) ->
    self = this
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

    dispatcher.bind 'connected', (message) ->
      console.log message

    dispatcher.bind 'disconnected', (message) ->
      console.log message

    player = self.$('audio')[0]

    # Add player and dispatcher to the controller.
    self.set 'controller.player', player

    # Set the pages title to the episode title.
    $(document).attr 'title', self.get('controller.model.title')

    dispatcher.on_open = (message) ->
      self.bindControlEvents(player, dispatcher, message.connection_id)
      self.bindEpisodeDataUpdate(player, dispatcher, message.connection_id)

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
