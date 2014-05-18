Buzz.PlayerView = Ember.View.extend
  templateName: 'player'

  # Add hooks to update control state
  bindControlEvents: (player, dispatcher) ->
    self = this

    id_hash = $('#user').data('id-hash')
    channel = dispatcher.subscribe(id_hash)

    # Used in adding dispatched events
    meta_addDispatchedEvent = (event, message_cb, dispatch_cb) ->
      # dispatch a message when the audio element triggers an event.
      player.addEventListener event, () ->
        message = if _.isFunction(message_cb) then message_cb() else {}
        dispatch_cb(message)
        self.get('controller').send("audio_#{event}", message)

      # send messages to the controller when an event is received from the
      # socket.
      channel.bind "audio.#{event}", (message) ->
        console.log "Caught #{event}: #{message}"
        self.get('controller').send("audio_#{event}", message)

    ##
    # Send an event to the controller and the socket.
    addDispatchedEvent = (event, message_cb) ->
      meta_addDispatchedEvent event, message_cb, (message) ->
        dispatcher.trigger "audio.#{event}", message

    ##
    # Send an event to the controller and the socket.
    # Limit the number of events sent with Ember.run.throttle.
    #
    # Ember.run matches methods by the context and the name of the method
    # but not the arguments
    # passing `dispatcher` and `trigger` as the context and method name
    # would throttle all events when I want to throttle each type of event
    # seperatly.
    #
    # My solution is to add methods to this dsp_events hash which should be
    # used as the context and the event name should be the method name.
    dsp_events = {}
    addThrottledDispatchedEvent = (event, limit, message_cb) ->
      dsp_events[event] ||= (message) -> dispatcher.trigger "audio.#{event}", message
      meta_addDispatchedEvent event, message_cb, (message) ->
        Ember.run.throttle dsp_events, event, message, limit

    # Bind basic events, those without messages.
    _(['play', 'pause', 'stalled']).each (basic_event) ->
      addDispatchedEvent basic_event

    # Mute/unmute or change the volume
    addDispatchedEvent 'volumechange', () ->
      { muted: player.muted, volume: player.volume }

    # Set the current tracks duration
    addDispatchedEvent 'durationchange', () ->
      { duration: player.duration }

    # Update the controllers buffered value
    # Send the events no less than a second apart
    addThrottledDispatchedEvent 'progress', 1000, () ->
        # The end of the last buffered segment
        buffered_chunks = player.buffered.length
        if buffered_chunks > 0
          buffered = player.buffered.end(buffered_chunks - 1)
        else
          buffered = 0
        return {buffered: buffered}

    # Update the controllers currentTime value
    # Send the events no less than a second apart
    addThrottledDispatchedEvent 'timeupdate', 1000, () ->
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
