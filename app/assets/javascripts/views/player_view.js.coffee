Buzz.PlayerView = Ember.View.extend
  templateName: 'player'

  ##
  # NOTE: I don't know why this isn't bound like the other actions, it might
  # have to do with getting the mouse position from the event.
  bind_scrubber: (player, dispatcher) ->
    self = this
    scrubber = self.$('#scrubber')

    # Bind seek events to the scrubber
    scrubber.bind 'click', (e) ->
      pos = e.clientX - e.currentTarget.getBoundingClientRect().left
      width = e.currentTarget.clientWidth
      message = { position: pos/width }

      self.get('controller').send('seek', pos/width)

  didInsertElement: () ->
    self = this

    this.bind_scrubber()

    websocket_uri = $('#websocket').data('uri')
    dispatcher = new WebSocketRails(websocket_uri, false)
    # Add the dispatcher to the controller.


    dispatcher.bind 'connected', (message) ->
      console.log message

    dispatcher.bind 'disconnected', (message) ->
      console.log message


    dispatcher.on_open = (message) ->
      id_hash = $('#user').data('id-hash')
      connection_id = message.connection_id

      channel = dispatcher.subscribe(id_hash)
      channel.bind 'local_player_changed', (message) ->
        console.log message

      self.set 'controller.dispatcher', dispatcher
      self.set 'controller.events_channel_id', id_hash
      self.set 'controller.commands_channel_id', connection_id

      self.get('controller').send 'create_remote_player'

    # Set the pages title to the episode title.
    $(document).attr 'title', self.get('controller.model.title')

  willDestroyElement: () ->
    # Unset the pages title.
    $(document).attr 'title', 'Buzz'
    this.get('controller').send 'unbind_events'
