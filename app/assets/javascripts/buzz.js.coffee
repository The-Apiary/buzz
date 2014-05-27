#= require ./store
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./components
#= require_tree ./views
#= require_tree ./templates
#= require_tree ./routes
#= require ./router
#= require_self

# Shamelessly taken from
# http://stackoverflow.com/questions/12168570/how-to-represent-arrays-within-ember-data-models/13884238#13884238
DS.JSONTransforms.array =

  serialize: (jsonData)->
    if Em.typeOf(jsonData) is 'array' then jsonData else []

  deserialize: (externalData)->
    switch Em.typeOf(externalData)
      when 'array'  then return externalData
      when 'string' then return externalData.split(',').map((item)-> jQuery.trim(item))
      else               return []

##
# Sends events from @element to the @dispatcher, prefixed with @namespace
class Buzz.LocalEventDispatcher
  constructor: (@element, @dispatcher, @namespace) ->
    @hooks = {}
    @dsp_events = {}

  ##
  # Returns the namespaced event name.
  event: (event) -> "#{@namespace}.#{event}"

  ##
  # Used in adding dispatched events NOTE: Private vars in coffeescript?
  meta_addDispatchedEvent: (event, message_cb, dispatch_cb) ->
    # dispatch a message when the audio element triggers an event.
    @element.addEventListener event, () =>
      message = if _.isFunction(message_cb) then message_cb() else {}
      @hooks[event](message) if _.isFunction(@hooks[event])
      dispatch_cb(message)

  ##
  # Send an event to the controller and the socket.
  addDispatchedEvent: (event, message_cb) ->
    @meta_addDispatchedEvent event, message_cb, (message) =>
      @dispatcher.trigger @event(event), message

  ##
  # Send an event to the controller and the socket.
  # Limit the number of events sent with Ember.run.throttle.
  #
  # Ember.run matches methods by the context and the name of the method
  # but not the arguments
  # passing `@dispatcher` and `trigger` as the context and method name
  # would throttle all events when instead I want to throttle each type of
  # event seperatly. A timeupdate event can immediatly follow a progress
  # event, but two progress events should be throttled.
  #
  # My solution is to dynamically add methods to the dsp_events hash.
  # The hash should be used as the context and the event name should be
  # the method name. Maybe there is a better way.
  addThrottledDispatchedEvent: (event, limit, message_cb) ->
    @dsp_events[event] ||= (message) =>
      @dispatcher.trigger @event(event), message
    @meta_addDispatchedEvent event, message_cb, (message) =>
      Ember.run.throttle @dsp_events, event, message, limit

class Buzz.RemoteEventListener
  constructor: (@channel, @namespace) ->

  ##
  # Returns the namespaced event name.
  event: (event) -> "#{@namespace}.#{event}"

  ##
  # Calls the callback when @namespace.event is triggered on @channel
  bind: (event, cb) ->
    @channel.bind @event(event), cb

class Buzz.RemoteControlDispatcher
  constructor: (@dispatcher, @namespace) ->

  ##
  # Returns the namespaced event name.
  event: (event) -> "#{@namespace}.#{event}"

  ##
  # Sends the event to the socket.
  trigger: (event, message) ->
    @dispatcher.trigger @event(event), message


##
# LocalPlayer and Remote player should have the same signiature, but
# either I or javascript suck at interfaces/abstract types.
#
# The constructors can be different.

##
# LocalPlayer
# Controls are sent directly to the @player noe,
# Events from the player node are sent to the socket.
#
# It listens to the connection_id channel for control events.
#
# `event_dispatcher` should be the basic dispatcher.
# `control_channel`  should be the connection_id channel.
# `player`           should be the player node.
class Buzz.LocalPlayer
  constructor: (event_dispatcher, control_channel, @player) ->
    ##
    # Send player events to the socket.
    @led = new Buzz.LocalEventDispatcher(@player, event_dispatcher, 'event')

    _(['play', 'pause', 'stalled']).each (basic_event) =>
      @led.addDispatchedEvent basic_event

    # Mute/unmute or change the volume
    @led.addDispatchedEvent 'volumechange', () =>
      { muted: @player.muted, volume: @player.volume }

    # Set the current tracks duration
    @led.addDispatchedEvent 'durationchange', () =>
      { duration: @player.duration }

    # Update the controllers buffered value
    # Send the events no less than a second apart
    @led.addThrottledDispatchedEvent 'progress', 1000, () =>
        # The end of the last buffered segment
        buffered_chunks = @player.buffered.length
        if buffered_chunks > 0
          buffered = @player.buffered.end(buffered_chunks - 1)
        else
          buffered = 0
        return {buffered: buffered}

    # Update the controllers currentTime value
    # Send the events no less than a second apart
    @led.addThrottledDispatchedEvent 'timeupdate', 1000, () =>
      { currentTime: @player.currentTime }

    ##
    # Listen to commands coming from remote controls.
    @rel = new Buzz.RemoteEventListener(control_channel, 'command')
    _(['play', 'pause', 'mute', 'unmute', 'seek']).each (event) =>
      @rel.bind event, @[event]

  ##
  #
  # Binds callbacks to events generated by @player
  # event should be on of the events bound in the constructor
  # cb should be a function that takes a message hash.
  bind: (event, cb) -> @led.hooks[event] = cb

  play:     () => @player.play()

  pause:    () => @player.pause()

  mute:     () => @player.muted = true

  unmute:   () => @player.muted = false

  seek: (perc) => @player.currentTime =  @player.duration * perc

##
# `event_channel` should be the id_hash channel.
# `command_dispatcher` should be the basic dispatcher.
class Buzz.RemotePlayer
  constructor: (event_channel, command_dispatcher) ->
    @rcd = new Buzz.RemoteControlDispatcher(command_dispatcher, 'command')
    @rel = new Buzz.RemoteEventListener(event_channel, 'event')

  bind: (event, cb) -> @rel.bind event, (message) -> cb(message)

  play:     () -> @rcd.trigger 'play'

  pause:    () -> @rcd.trigger 'pause'

  mute:     () -> @rcd.trigger 'mute'

  unmute:   () -> @rcd.trigger 'unmute'

  seek: (perc) -> @rcd.trigger 'seek', perc
